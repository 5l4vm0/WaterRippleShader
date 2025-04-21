Shader "Custom/Ripple"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _Texture("Texture", 2D) = "white"{}
        _Decay("Decay", float) = 5
        _WaveLiftTime("Wave Life Time", Range(1,10)) = 2
        _WaveFrequency("Wave Frequency", float) = 25
        _WaveSpeed("Wave Speed", float) = 3
        _WaveStrength("Wave Strength", float) = 0.3
    }

    SubShader
    {
        pass
        {   
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            float4 _Color;
            sampler2D _Texture;
            float _Decay, _WaveLiftTime, _WaveFrequency, _WaveSpeed, _WaveStrength;

            //InputCentre array : xy = input centre, z = start time
            float4 _InputCentre[10];
            
            struct VertexInput
            {
                float4 pos: POSITION;
                float2 uv:TEXCOORD;
            };
            
            struct VertexOutput
            {
                float4 pos: SV_POSITION;
                float2 uv:TEXCOORD;
            };
            
            //wave calculation
            float Wave(float2 uv, float2 centre, float startTime)
            {
                if(startTime <=0) return 0;
                
                //discard old wave
                float age = _Time.y - startTime;
                if(age>_WaveLiftTime) return 0;

                float2 offset = uv-centre;
                float distanceFromCentre = length(offset);
                
                // Base cosine wave calculation
                float wave = cos(distanceFromCentre *_WaveFrequency - _Time.y*_WaveSpeed)*0.5+0.5;

                //distance-based decay
                float spatialDecay = 1.0 - saturate(distanceFromCentre * _Decay);

                //applied time to decay
                float decay = spatialDecay * (1-age/_WaveLiftTime);
                
                return wave * _WaveStrength * decay;
            }
            

            VertexOutput vert(VertexInput i)
            {
                VertexOutput o;
                float combinedWave=0;

                // Accumulate up to 10 waves
                UNITY_LOOP
                for(int n =0; n<10; n++)
                {
                    combinedWave += Wave(i.uv, _InputCentre[n].xy,_InputCentre[n].z);
                }

                // Offset vertex height by combined wave
                i.pos.y = combinedWave*0.5;
                o.pos = UnityObjectToClipPos(i.pos);
                o.uv = i.uv;
                return o;
            }

            float4 frag(VertexOutput o):SV_TARGET
            {
                float4 tex = tex2D(_Texture, o.uv);
                float combinedWave=0;

                // Accumulate wave intensity again for visual effect
                UNITY_LOOP
                for(int n =0; n<10; n++)
                {
                    if(combinedWave > 1.0) continue;
                    combinedWave += Wave(o.uv, _InputCentre[n].xy,_InputCentre[n].z);
                }
                
                return max(0.0, saturate(combinedWave*_Color)+tex);
            }

            ENDCG
        }
    }
}

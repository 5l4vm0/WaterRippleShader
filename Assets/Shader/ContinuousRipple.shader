Shader "Custom/ContinuousRipple"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _Texture("Texture", 2D) = "white"{}
        _Decay("Decay", Range(0,10)) = 5
        _WaveFrequency("Wave Frequency", Range(0,100)) = 25
        _WaveSpeed("Wave Speed", Range(0,10)) = 3
        _WaveStrength("Wave Strength",  Range(0,5)) = 0.3
        _StencilRef("Stencil Ref", Range(0,255)) = 1
    }

    SubShader
    {
        pass
        {   
            Stencil{
                ref [_StencilRef]
                comp Equal
                pass replace
            }

            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            float4 _Color;
            sampler2D _Texture;
            float4 _Texture_ST;
            float _Decay, _WaveFrequency, _WaveSpeed, _WaveStrength;

            //InputCentre array : xy = input centre, z = start time
            float4 _InputCentre;
            
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

                float2 offset = uv-centre;
                float distanceFromCentre = length(offset);
                
                // Base cosine wave calculation
                float wave = cos(distanceFromCentre *_WaveFrequency - _Time.y*_WaveSpeed)*0.5+0.5;

                //distance-based decay
                float spatialDecay = 1.0 - saturate(distanceFromCentre * _Decay);
                
                return wave * _WaveStrength * spatialDecay;
            }
            

            VertexOutput vert(VertexInput i)
            {
                VertexOutput o;
                // float combinedWave=0;

                // // Accumulate up to 10 waves
                // UNITY_LOOP
                // for(int n =0; n<10; n++)
                // {
                //     combinedWave += Wave(i.uv, _InputCentre[n].xy,_InputCentre[n].z);
                // }

                // Offset vertex height by combined wave
                float wave;
                wave = Wave(i.uv,_InputCentre.xy,_InputCentre.z);
                i.pos.y = wave*0.5;
                o.pos = UnityObjectToClipPos(i.pos);
                o.uv = TRANSFORM_TEX(i.uv, _Texture);
                return o;
            }

            float4 frag(VertexOutput o):SV_TARGET
            {
                float4 tex = tex2D(_Texture, o.uv);
                // float combinedWave=0;

                // // Accumulate wave intensity again for visual effect
                // UNITY_LOOP
                // for(int n =0; n<10; n++)
                // {
                //     if(combinedWave > 1.0) continue;
                //     combinedWave += Wave(o.uv, _InputCentre[n].xy,_InputCentre[n].z);
                // }

                float wave;
                wave = Wave(o.uv,_InputCentre.xy,_InputCentre.z);
                
                
                return max(0.0, saturate(wave*_Color)+tex);
            }

            ENDCG
        }
    }
}

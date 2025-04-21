using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectCollisionRipple : MonoBehaviour
{
    [SerializeField] private MeshRenderer ripplePlane;
    private Collider ripplePlaneCollider;
    private Vector4[] ripplePoints = new Vector4[10];
    private int rippleIndex = 0;
    private Vector2 _oldInputCentre;

    void Start()
    {
        ripplePlaneCollider = ripplePlane.GetComponent<Collider>();
    }
    void OnCollisionStay(Collision other)
    {
        if (ripplePlaneCollider != null && other.collider == ripplePlaneCollider)
        {
            ContactPoint[] contactPoints = other.contacts;
            foreach (ContactPoint contact in contactPoints)
            {
                // Raycast to get texture coordinate from contact point
                Ray ray = new Ray(contact.point + contact.normal * 0.01f, -contact.normal);
                RaycastHit hit;

                if (Physics.Raycast(ray, out hit, 1.0f))
                {
                    Vector2 uv = hit.textureCoord;
                    if (_oldInputCentre != null && Vector2.Distance(_oldInputCentre, uv) < 0.1f) return;
                    
                    ripplePoints[rippleIndex] = new Vector4(uv.x, uv.y, Time.time, 0);
                    rippleIndex = (rippleIndex + 1) % ripplePoints.Length;
                    _oldInputCentre = uv;
                }
            }
            ripplePlane.material.SetVectorArray("_InputCentre", ripplePoints);
        }
    }

}

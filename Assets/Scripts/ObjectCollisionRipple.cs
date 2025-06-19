using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Eldvmo.Ripples
{
    public class ObjectCollisionRipple : MonoBehaviour
    {
        private bool isInWater = false;
        [SerializeField] private MeshRenderer ripplePlane;
        private Collider ripplePlaneCollider;
        private Vector4[] ripplePoints = new Vector4[10];
        private int rippleIndex = 0;
        private Vector2 _oldInputCentre;
        private int waterLayerMask;
        [SerializeField] private Collider waterTrigger;
        [SerializeField] bool isFloatingWithWater = true;
        [SerializeField] float moveUpHeight = 2f;
        private Rigidbody rb;

        void Start()
        {
            ripplePlaneCollider = ripplePlane.GetComponent<Collider>();
            waterLayerMask = LayerMask.GetMask("Water");
            rb = GetComponent<Rigidbody>();
        }

        void OnTriggerEnter(Collider other)
        {
            if (ripplePlaneCollider != null && other == waterTrigger)
            {
                isInWater = true;
            }
        }

        void OnTriggerExit(Collider other)
        {
            if (ripplePlaneCollider != null && other == waterTrigger)
            {
                isInWater = false;
            }
        }

        void FixedUpdate()
        {
            if (!isInWater) return;
            //Raycast from the object toward the plane
            Vector3 origin = transform.position + Vector3.up * 0.5f;
            Vector3 direction = Vector3.down;

            Ray ray = new Ray(origin, direction);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit, 2f, waterLayerMask))
            {
                Vector2 uv = hit.textureCoord;

                if (_oldInputCentre != null && Vector2.Distance(_oldInputCentre, uv) < 0.05f) return;

                ripplePoints[rippleIndex] = new Vector4(uv.x, uv.y, Time.time, 0);
                rippleIndex = (rippleIndex + 1) % ripplePoints.Length;
                _oldInputCentre = uv;

                //Set ripple centre (ray hit point) to ripple material
                ripplePlane.material.SetVectorArray("_InputCentre", ripplePoints);

                //Moving boat up and down
                if (!isFloatingWithWater) return;

                SetObjectHeight(hit.point.y + moveUpHeight);
                rb.useGravity = false;
                StartCoroutine(EnableGravity());
            }
        }

        private void SetObjectHeight(float targetHeight)
        {
            Vector3 currentPos = transform.position;
            currentPos.y = Mathf.Lerp(currentPos.y, targetHeight, Time.fixedDeltaTime * 0.5f);
            transform.position = currentPos;
        }

        //Fake boat skipping wave
        private IEnumerator EnableGravity()
        {
            yield return new WaitForSeconds(0.5f);
            rb.useGravity = true;
        }
    }
}
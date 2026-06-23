using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotationScript : MonoBehaviour
{
    private void FixedUpdate()
    {
        transform.Rotate(Vector3.forward * 10 * Time.deltaTime);
    }
}

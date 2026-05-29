using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class epicentro1 : MonoBehaviour
{

    [SerializeField] private Material mtl;
    [SerializeField] private Vector3 epicentro;

    // Update is called once per frame
    void Update()
    {
        mtl.SetVector("_epicentro", epicentro);
    }
}

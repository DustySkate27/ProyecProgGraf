using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Detectable : MonoBehaviour
{
    [SerializeField] private Material material;
    private bool detect = false;

    private void Awake()
    {
        material.SetFloat("_1Act0Inac", detect ? 1.0f : 0.0f);
        material.SetFloat("_index", detect ? (float)UnityEngine.Rendering.CompareFunction.Greater : (float)UnityEngine.Rendering.CompareFunction.Equal);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            detect = !detect;
            material.SetFloat("_1Act0Inac", detect ? 1.0f : 0.0f);
            material.SetFloat("_index", detect ? (float)UnityEngine.Rendering.CompareFunction.Greater : (float)UnityEngine.Rendering.CompareFunction.Equal);
        }
    }
}

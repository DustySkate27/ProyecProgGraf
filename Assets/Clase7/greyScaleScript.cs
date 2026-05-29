using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class greyScaleScript : MonoBehaviour
{
    [SerializeField] private Shader shader;
    private Material material;

    public float greyLevel;
    private void Awake()
    {
        material = new Material(shader);
    }

    private void Update()
    {
        material.SetFloat("_greylevel", greyLevel);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}

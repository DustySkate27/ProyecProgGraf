using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class motionBlurScript : MonoBehaviour
{
    [SerializeField] private Shader shader;
    private Material material;

    public Vector2 blur1;

    private void Awake()
    {
        material = new Material(shader);
    }

    private void Update()
    {
        material.SetVector("_blur1", blur1);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}

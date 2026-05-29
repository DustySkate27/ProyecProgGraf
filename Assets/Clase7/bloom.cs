using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class bloom : MonoBehaviour
{
    [SerializeField] private Shader shader;
    private Material material;

    public Vector3 bloomFactor;
    public float min;
    public float max;
    public Vector2 blur;

    private void Awake()
    {
        material = new Material(shader);
    }

    private void Update()
    {
        material.SetVector("_bloom", bloomFactor);
        material.SetFloat("_min", min);
        material.SetFloat("_max", max);
        material.SetVector("_blur", blur);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}

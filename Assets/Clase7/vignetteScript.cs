using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class vignetteScript : MonoBehaviour
{
    [SerializeField] private Shader shader;
    private Material material;

    public Vector2 center;
    public float min;
    public float max;

    private void Awake()
    {
        material = new Material(shader);
    }

    private void Update()
    {
        material.SetVector("_center", center);
        material.SetFloat("_minFloat", min);
        material.SetFloat("_maxFloat", max);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}

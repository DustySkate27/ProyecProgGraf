using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TonSatBriConScript : MonoBehaviour
{
    [SerializeField] private Shader shader;
    private Material material;

    public Color color;
    public float contrast;
    public float saturation;
    public float brightness;

    private void Awake()
    {
        material = new Material(shader);
    }

    private void Update()
    {
        material.SetColor("_color", color);
        material.SetFloat("_contrast", contrast);
        material.SetFloat("_saturation", saturation);
        material.SetFloat("_brightness", brightness);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}

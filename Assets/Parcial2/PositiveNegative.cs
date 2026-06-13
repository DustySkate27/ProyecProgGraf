using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PositiveNegative : MonoBehaviour
{
    [SerializeField] private Shader shader;
    private Material material;
    [SerializeField] private Projector projector;

    public Color positive;
    public Color negative;

    private void Awake()
    {
        material = new Material(shader);
        projector.material = material;
        material.SetColor("_Color0", negative);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            if(material.GetColor("_Color0") == positive)
            {
                material.SetColor("_Color0", negative);
            }
            else
            {
                material.SetColor("_Color0", positive);
            }
        }

    }
}

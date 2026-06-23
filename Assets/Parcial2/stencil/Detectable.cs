using UnityEngine;

public class Detectable : MonoBehaviour
{
    [SerializeField] private Material material;
    private bool detect = false;
    private float detectCount = 0;
    [SerializeField] private int layer;

    private void Awake()
    {
        material.renderQueue = 1000;
    }

    // Update is called once per frame
    void Update()
    {
        if (detect)
        {
            VisionActivated();
            detectCount += Time.deltaTime;
            if (detectCount > 2)
            {
                detectCount = 0;
                detect = VisionDeactivated();
            }
        }
    }

    private bool VisionActivated()
    {
        material.renderQueue = 3000;

        return true;
    }
    private bool VisionDeactivated()
    {
        material.renderQueue = 1000;
        return false;
    }

    private void OnTriggerEnter(Collider collision)
    {
        if(collision.gameObject.layer == layer)
        {
            Debug.Log(collision.gameObject.name);
            detect = true;
        }
    }

}

using UnityEngine;

public class PlayerScript : MonoBehaviour
{
    [SerializeField] private float radius;
    [SerializeField] private float radLimit;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.A))
        {
            radius = 0;
        }
        else if (radius < radLimit)
        {
            radius += Time.deltaTime * 50;
            transform.localScale = new Vector3(radius, radius, radius) * 2;
        }
        else
        {
            transform.localScale = new Vector3(0, 0, 0);
        }
            
    }
}

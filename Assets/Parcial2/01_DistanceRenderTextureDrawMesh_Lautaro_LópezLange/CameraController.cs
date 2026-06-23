using UnityEngine;

public class CameraController : MonoBehaviour
{
    [SerializeField] private Rigidbody rb;
    [SerializeField] private float speed = 5f;

    private float moveX;
    private float moveZ;

    void Update()
    {
        moveX = Input.GetAxisRaw("Horizontal");  
        moveZ = Input.GetAxisRaw("Vertical");    
    }

    void FixedUpdate()
    {
        Vector3 movement = new Vector3(moveX, 0f, moveZ).normalized;
        rb.velocity = new Vector3(movement.x * speed, rb.velocity.y, movement.z * speed);
    }
}
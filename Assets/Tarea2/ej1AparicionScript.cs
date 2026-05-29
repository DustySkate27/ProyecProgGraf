using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class spawnScript : MonoBehaviour
{

    [SerializeField] private GameObject hologram;
    private float duration = 0;
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) && duration == 0)
        {
            hologram.SetActive(true);
            duration = 0.1f;
        }

        if(duration>0) 
            duration += Time.deltaTime;
        if (duration > 2)
        {
            hologram.SetActive(false);
            duration = 0;
        }
    }
}

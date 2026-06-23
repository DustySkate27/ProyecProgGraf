using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;

    [SerializeField] private List<GameObject> assetList;
    [SerializeField] private GameObject cam;
    private GameObject currentGoal;
    [SerializeField] private LayerMask objLayer;
    private int points;

    private void Awake()
    {
        if (Instance != null)
        {
            Instance = this;
        }
        else
            DontDestroyOnLoad(this);

            points = 0;
        InitCam();
    }

    private void InitCam()
    {
        currentGoal = assetList[Random.Range(0, assetList.Count)];
        cam.transform.position = new Vector3 (currentGoal.transform.position.x, cam.transform.position.y, currentGoal.transform.position.z);
    }

    private void HitsTheTarget(Transform raycaster)
    {
        if (Physics.Raycast(raycaster.position, raycaster.forward, out RaycastHit hit, 100f) && hit.transform == currentGoal.transform)
        {
            currentGoal = null;
            points++;
            InitCam();
        }
    }

}

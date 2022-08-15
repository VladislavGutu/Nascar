using System;
using System.Collections;
using System.Collections.Generic;
using MyBox;
using UnityEngine;
using UnityStandardAssets.Utility;
using UnityStandardAssets.Vehicles.Car;
using Random = UnityEngine.Random;

public class CarRefs : MonoBehaviour
{
    [SerializeField] private RCC_CarControllerV3 carControllerV3;
    [SerializeField] private RCC_Recorder recorder;
    [SerializeField] private CarController carController;
    [SerializeField] private CarAIControl carAIControl;
    [SerializeField] private WaypointProgressTracker waypointProgressTracker;

    [SerializeField] private bool isMine = false;
    [SerializeField] private int indexCar = -1;
    public int carPrice;
    public bool inTimeUse = true;

    public RCC_CarControllerV3 CarControllerV3 => carControllerV3;

    public RCC_Recorder Recorder => recorder;

    public CarController CarController => carController;

    public CarAIControl CarAIControl => carAIControl;

    public WaypointProgressTracker WaypointProgressTracker => waypointProgressTracker;

    public bool IsMine
    {
        get => isMine;
        set
        {
            isMine = value;
            carControllerV3.isMine = value;
        }
    }

    public int IndexCar
    {
        get
        {
            if (indexCar == -1)
            {
                indexCar = Random.Range(1000, 9999999);
            }

            return indexCar;
        }
    }

    public float time, startTime;
    public int circle;

    private void Start()
    {
        
            startTime = Time.time;
    }

    private void Update()
    {
        if (inTimeUse)
        time = Time.time - startTime;
    }

    public void stopTime()
    {
        inTimeUse = false;
    }
}
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using MyBox;
using UnityEngine;

[CreateAssetMenu(order = 1, fileName = "CarInfoListSO", menuName = "CarData/CarInfoListSO")]
public class CarInfoListSO : ScriptableObject
{
    [SerializeField] private List<GameObject> cars;

    public GameObject GetCar(int index)
    {
        int localIndex = 0;
        if (index < 0)
        {
            localIndex = 0;
        } else if (index >= cars.Count)
        {
            localIndex = cars.Count - 1;
        }
        else
        {
            localIndex = index;
        }

        return cars[localIndex];

    }
    
}
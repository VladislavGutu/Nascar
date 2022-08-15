using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using DG.Tweening;
using Newtonsoft.Json;
using Rewired;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class CarManager : MonoBehaviour, ISelectHandler 
{
    [SerializeField] private List<GameObject> _carList;
    [SerializeField] private UIManager _uiManager;
    
    [SerializeField] private GameObject _raceModeGO;
    [SerializeField] private GameObject blockedCarImg;
    
    [SerializeField] private RectTransform noMoneyPopUp;
    [SerializeField] private RectTransform _contentPos;


    int selectedCar = 0;
    int activeCar = 0;


    // Start is called before the first frame update
    void Start()
    {
        _carList[StaticSavePrefs.LoadIntPref(StaticCommunicationChannel.KEY_CURRENT_CAR)].SetActive(true);
        
        if (!SaveBridge.HasKeyPP(StaticCommunicationChannel.KEY_BOUGHT_CARS))
        {
            List<int> boughtCar = new List<int>();
            boughtCar.Add(0);
            string SaveBoughtCars = JsonConvert.SerializeObject(boughtCar);
            StaticSavePrefs.SavePrefs(StaticCommunicationChannel.KEY_BOUGHT_CARS, SaveBoughtCars);
            
            Debug.LogError("Start: " + SaveBoughtCars);
        }
        
        PreviewCar(0);
    }

    private void SaveBuyedCars(int i)
    {
        List<int> boughtCar = LoadBuyedCars();
        if (boughtCar.Contains(i))
        {
            return;
        }
        boughtCar.Add(i);

        string SaveBoughtCars = JsonConvert.SerializeObject(boughtCar);
        
        Debug.LogError("Save: " + SaveBoughtCars);
        StaticSavePrefs.SavePrefs(StaticCommunicationChannel.KEY_BOUGHT_CARS, SaveBoughtCars);
    }

    private List<int> LoadBuyedCars()
    {
        List<int> buyedCarsList =
            JsonConvert.DeserializeObject<List<int>>(
                StaticSavePrefs.LoadStringPref(StaticCommunicationChannel.KEY_BOUGHT_CARS));
        return buyedCarsList;
    }

    public void PreviewCar(int i)
    {
        foreach (GameObject go in _carList)
        {
            go.SetActive(false);
        }

        _carList[i].SetActive(false);
        _carList[i].SetActive(true);

        selectedCar = i;

        List<int> boughtCar = LoadBuyedCars();
        
        if(boughtCar.Contains(i))
            blockedCarImg.SetActive(false);
        else
        {
            blockedCarImg.SetActive(true);
            if (_carList[i].TryGetComponent(out CarRefs refs)) 
            {
                _uiManager.carPrice.text = refs.carPrice + "$";
            }
        }
    }

    public void SelectCar()
    {
        List<int> boughtCar = LoadBuyedCars();

        if (_carList[selectedCar].TryGetComponent(out CarRefs refs)) 
        {
            if (boughtCar.Contains(selectedCar))
            {
                _uiManager.OpenPanel(_raceModeGO);
            }
            else
            {
                if (refs.carPrice > StaticSavePrefs.LoadIntPref(StaticCommunicationChannel.KEY_USER_MONEY))
                {
                    noMoneyPopUp.DOAnchorPosY(0, .5f);
                
                    DOVirtual.DelayedCall(2.5f, () =>
                    {
                        noMoneyPopUp.DOAnchorPosY(500f, .25f);
                    });
                }
                else
                {
                    StaticSavePrefs.SavePrefs(StaticCommunicationChannel.KEY_USER_MONEY, StaticSavePrefs.LoadIntPref(StaticCommunicationChannel.KEY_USER_MONEY) - refs.carPrice);
                    StaticSavePrefs.SavePrefs(StaticCommunicationChannel.KEY_CURRENT_CAR, selectedCar);
                    SaveBuyedCars(selectedCar);
        
                    // _uiManager.OpenPanel(_raceModeGO);
                    blockedCarImg.SetActive(boughtCar.Contains(selectedCar));
                    _uiManager.playerCash.text = StaticSavePrefs.LoadIntPref(StaticCommunicationChannel.KEY_USER_MONEY) + "$";
                }
            }
        }
    }

    public void OnSelect(BaseEventData eventDat)
    {
        
    }

    /*
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            PreviousCar();
        }
        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            NextCar();
        }
        
    }

    public void NextCar()
    {
        _carList[activeCar].SetActive(false);
        activeCar++;
        
        if (activeCar >= _carList.Count)
            activeCar = 0;
        
        _carList[activeCar].SetActive(true);
    }
    public void PreviousCar()
    {
        _carList[activeCar].SetActive(false);
        
        activeCar--;
        
        if (activeCar < 0)
            activeCar = _carList.Count - 1;
        
        _carList[activeCar].SetActive(true);
    }
    */
}

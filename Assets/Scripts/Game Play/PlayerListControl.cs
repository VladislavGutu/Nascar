using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using MyBox;
using UnityEngine;
using UnityEngine.UI;

public class PlayerListControl : Singleton<PlayerListControl>
{
    [SerializeField] private PlayerInList _playerInListGO;
    [SerializeField] private Transform parent;
    private List<PlayerInList> _playerInLists = new List<PlayerInList>();
    
    public class playerTimeCar
    {
        public int laps;
        public float time;
    }
    
    private Dictionary<CarRefs, playerTimeCar> _playerTime;
    private int lastIndex;

    private string[] namesBot = new[] {"Liam", "Olivia", "William", "Sophia", "Benjamin", "Lucas", "Henry", "Theodore", "Elijah", "Harper", "Charlotte"};

    private void Awake()
    {
        _playerTime = new Dictionary<CarRefs, playerTimeCar>();
    }

    public void CreateItem(int pos, CarRefs bot)
    {
        var temp = Instantiate(_playerInListGO, parent);
        temp.gameObject.SetActive(true);
        temp.car = bot;
        var tempDataCars = new playerTimeCar()
        {
            laps = 0,
            time = 0
        };
        _playerTime.Add(bot, tempDataCars);
        temp.Init(pos+1,namesBot[pos],bot,tempDataCars);
        lastIndex = pos+1;
        _playerInLists.Add(temp);
        
    }

    public async void StartRace()
    {
        while (true)
        {
            _playerInLists.ForEach(x =>
            {
                var newList = GetCorrectListPlayer();
                KeyValuePair<CarRefs, playerTimeCar> carFind = newList.ToList().Find(y => y.Key.IndexCar == x.car.IndexCar);
                x.ChangeUI(carFind.Value.time);
            });
            
            await new WaitForSeconds(4f);
        }
    }

    public void SetTimePlayer(int circleTemp, CarRefs car)
    {
        if (car.inTimeUse)
        {
            _playerTime[car].time = car.time;
            _playerTime[car].laps += circleTemp;
            car.circle = _playerTime[car].laps;
            UpdateListUI();
        }

        if (_playerTime[car].laps > StaticCommunicationChannel.circles)
        {
            car.stopTime();
        }
        
    }

    public IEnumerable<KeyValuePair<CarRefs, playerTimeCar>> GetCorrectListPlayer()
    {
        List<KeyValuePair<CarRefs, playerTimeCar>> lap0 = _playerTime.Where(x => x.Value.laps == 0).OrderBy(x => x.Value.time).ToList();
        List<KeyValuePair<CarRefs, playerTimeCar>> lap1 = _playerTime.Where(x => x.Value.laps == 1).OrderBy(x => x.Value.time).ToList();
        List<KeyValuePair<CarRefs, playerTimeCar>> lap2 = _playerTime.Where(x => x.Value.laps == 2).OrderBy(x => x.Value.time).ToList();
        
        return lap2.Union(lap1).Union(lap0);
    }

    private void UpdateListUI()
    {
        var newList = GetCorrectListPlayer();
        
        int index = 0;
        foreach (var (key, _) in newList)
        {
           PlayerInList carFind = _playerInLists.Find(x => x.car.IndexCar == key.IndexCar);
           carFind.transform.SetSiblingIndex(index);
           carFind.SetPosition(index+1);
           index++;
        }
    }

    public void CreateItemPlayer(CarRefs myCar)
    {
        var temp = Instantiate(_playerInListGO, parent);
        temp.gameObject.SetActive(true);
        if (ColorUtility.TryParseHtmlString("#296600", out Color colorNew))
        {
            temp.GetComponent<Image>().color = colorNew;
        }
        
        var tempDataCars = new playerTimeCar()
        {
            laps = 0,
            time = 0
        };
        
        temp.Init(lastIndex+1,"Player",myCar,tempDataCars);
        _playerInLists.Add(temp);
        _playerTime.Add(myCar, tempDataCars);
    }
}
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using DG.Tweening;
using MyBox;
using Newtonsoft.Json;
using Rewired;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityStandardAssets.Utility;

public class GamePlayerContoller : Singleton<GamePlayerContoller>
{
    private GameType _gameType;
    private int _raceOpponents, circlesRace, circleEnds;
    private CarRefs _timeActiveBot;
    private RCC_Recorder.Recorded recorded;
    public GameObject loadingImage;
    private bool canUsePause = true, inPause = false;


    private Dictionary<int, CarRefs> _occupiedPoint;
    private float myTime;
    private bool inRace;

    [SerializeField] private List<CarRefs> bots;
    [SerializeField] private List<Transform> spawnPoints;
    [SerializeField] private CarRefs myCar;
    [SerializeField] private bool[] triggerList;
    [SerializeField] private List<TriggerCheckPoint> _triggerCheckPoints;
    [SerializeField] private int timeToWaitBeforeStart = 2;
    [SerializeField] private CarInfoListSO allCarsData;
    [SerializeField] private RCC_UIDashboardButton _buttonFinishGameCamera;
    [SerializeField] private WaypointCircuit _waypointCircuit;
    [SerializeField] private Image finishBG;

    [SerializeField] private UnityEvent Time3,
        Time2,
        Time1,
        StartGame,
        AfterStartGameDisableUI,
        EnableFinishTrigger,
        FinishGame,
        FinishDisableUI;

    [SerializeField] private UnityEvent<bool> RaceUI, TimeUI, pauseUIEvent;

    [SerializeField] private UnityEvent<string> myTimeText, bestTime, circlesText, finishMyTime;
    public int timeAfterStartCloseStartUI = 3;


    [Separator("Finish UI")] [SerializeField]
    private TextMeshProUGUI _meshProUGUI, myTimeFinish;

    [SerializeField] private GameObject buttons;
    
    [SerializeField] private GameObject pauseButton;
    [SerializeField] private GameObject finishButton;

    private void Awake()
    {
        _occupiedPoint = new Dictionary<int, CarRefs>();
        triggerList = new[] {false, false, false, false, false, false};
    }

    public void TriggerCheck(int index)
    {
        triggerList[index] = true;
        if (triggerList.All(x => x))
        {
            EnableFinishTrigger?.Invoke();
        }
    }

    public async void Start()
    {
        _gameType = StaticCommunicationChannel.GameType;
        _raceOpponents = StaticCommunicationChannel.raceOpponents;
        circlesRace = StaticCommunicationChannel.circles;

        int indexMyCar = StaticSavePrefs.LoadIntPref(StaticCommunicationChannel.KEY_CURRENT_CAR);
        GameObject temp = allCarsData.GetCar(indexMyCar);

        if (_gameType == GameType.TIME)
        {
            // TIME
            TimeUI?.Invoke(true);
            RaceUI?.Invoke(false);
            recorded = LoadFromMemory();

            if (recorded != null)
            {
                GameObject tempCar = Instantiate(allCarsData.GetCar(indexMyCar), spawnPoints[0].position,
                    spawnPoints[0].rotation);
                tempCar.TryGetComponent(out _timeActiveBot);
                _timeActiveBot.CarControllerV3.enabled = true;
                _timeActiveBot.Recorder.Play(recorded);
                string minutes = ((int) recorded.topTime / 60).ToString();
                string seconds = (recorded.topTime % 60).ToString("f2");
                bestTime?.Invoke(minutes + ":" + seconds);
            }
        }
        else if (_gameType == GameType.RACE)
        {
            // RACE

            TimeUI?.Invoke(false);
            RaceUI?.Invoke(true);
            circlesText?.Invoke($"{circleEnds + 1}/{circlesRace}");
            foreach (TriggerCheckPoint triggerCheckPoint in _triggerCheckPoints)
            {
                triggerCheckPoint.SetCircle(circlesRace);
            }

            for (int i = 0; i < _raceOpponents; i++)
            {
                bots[i].gameObject.SetActive(true);
                bots[i].CarController.enabled = true;
                bots[i].WaypointProgressTracker.enabled = true;
                _occupiedPoint.Add(i, bots[i]);
                PlayerListControl.Instance.CreateItem(i, bots[i]);
            }
        }

        if (myCar == null)
        {
            for (var index = 0; index < spawnPoints.Count; index++)
            {
                Transform spawnPoint = spawnPoints[index];

                if (!_occupiedPoint.ContainsKey(index))
                {
                    GameObject tempCar = Instantiate(temp, spawnPoint.position, spawnPoint.rotation);
                    tempCar.TryGetComponent(out myCar);
                    myCar.CarControllerV3.canControl = false;
                    myCar.CarControllerV3.enabled = true;
                    myCar.IsMine = true;
                    myCar.WaypointProgressTracker.Circuit = _waypointCircuit;
                    _occupiedPoint.Add(index, myCar);
                    PlayerListControl.Instance.CreateItemPlayer(myCar);
                    break;
                }
            }
        }

        if (_gameType == GameType.TIME)
        {
            myCar.Recorder.Record();
        }


        await new WaitForSeconds(timeToWaitBeforeStart);
        StartRace();
    }

    private void Update()
    {
        if (ReInput.players.GetPlayer(0).GetButtonDown("Pause"))
        {
            PauseUI();
            
        }
    }

    IEnumerator StartTime()
    {
        float startTime = Time.time;
        while (inRace)
        {
            myTime = Time.time - startTime;
            string minutes = ((int) myTime / 60).ToString();
            string seconds = (myTime % 60).ToString("f2");
            myTimeText?.Invoke(minutes + ":" + seconds);


            yield return new WaitForSeconds(0.001f);
        }
    }

    private void StartRace()
    {
        Time3?.Invoke();
        DOVirtual.DelayedCall(1f, (() =>
        {
            Time2?.Invoke();
            DOVirtual.DelayedCall(1f, (() =>
            {
                Time1?.Invoke();
                DOVirtual.DelayedCall(1f, (() =>
                {
                    StartGame?.Invoke();
                    myCar.CarControllerV3.canControl = true;
                    foreach (var (key, value) in _occupiedPoint)
                    {
                        if (value != myCar)
                        {
                            value.gameObject.SetActive(true);
                            if (_gameType == GameType.RACE)
                            {
                                value.CarAIControl.enabled = true;
                            }
                        }
                    }

                    inRace = true;
                    PlayerListControl.Instance.StartRace();
                    StartCoroutine(StartTime());

                    DOVirtual.DelayedCall(timeAfterStartCloseStartUI, () => AfterStartGameDisableUI?.Invoke());
                }));
            }));
        }));
    }


    private RCC_Recorder.Recorded LoadFromMemory()
    {
        string key = StaticCommunicationChannel.KEY_TOP_TIME_BOT;

        RCC_Recorder.Recorded _recorded = new RCC_Recorder.Recorded();
        string carData = PlayerPrefs.GetString(key, "");

        if (carData.IsNullOrEmpty())
        {
            return null;
        }

        Dictionary<string, string> carDataMoveMemory =
            JsonConvert.DeserializeObject<Dictionary<string, string>>(carData);

        _recorded.inputs = JsonConvert.DeserializeObject<RCC_Recorder.PlayerInput[]>(carDataMoveMemory["inputs"]);
        _recorded.transforms =
            JsonConvert.DeserializeObject<RCC_Recorder.PlayerTransform[]>(carDataMoveMemory["transforms"]);
        _recorded.rigids = JsonConvert.DeserializeObject<RCC_Recorder.PlayerRigidBody[]>(carDataMoveMemory["rigids"]);
        _recorded.topTime = (float.Parse(carDataMoveMemory["TopTime"]));

        return _recorded;
    }

    public void SaveInMemory(RCC_Recorder.Recorded recorded)
    {
        if (myTime <= recorded.topTime)
        {
            return;
        }

        Dictionary<string, string> carDataMoveMemory = new Dictionary<string, string>();

        carDataMoveMemory.Add("TopTime", myTime.ToString());

        carDataMoveMemory.Add("inputs", JsonConvert.SerializeObject(recorded.inputs, Formatting.None,
            new JsonSerializerSettings()
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            }));
        carDataMoveMemory.Add("transforms", JsonConvert.SerializeObject(recorded.transforms, Formatting.None,
            new JsonSerializerSettings()
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            }));
        carDataMoveMemory.Add("rigids", JsonConvert.SerializeObject(recorded.rigids, Formatting.None,
            new JsonSerializerSettings()
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            }));

        string CarDataMemory = JsonConvert.SerializeObject(carDataMoveMemory);

        StaticSavePrefs.SavePrefs(StaticCommunicationChannel.KEY_TOP_TIME_BOT, CarDataMemory);
    }


    public async void Finish()
    {

        canUsePause = false;
        buttons.gameObject.SetActive(false);
        FinishDisableUI?.Invoke();

        inRace = false;
        myCar.CarControllerV3.canControl = false;
        if (_gameType == GameType.TIME)
        {
            myCar.Recorder.Stop();
            myCar.Recorder.SaveRecord();
        }
        else if (_gameType == GameType.RACE)
        {
        }

        myCar.Recorder.enabled = false;
        myCar.CarControllerV3.enabled = false;
        myCar.CarController.enabled = true;
        myCar.WaypointProgressTracker.enabled = true;
        myCar.CarAIControl.enabled = true;

        _buttonFinishGameCamera._buttonType = RCC_UIDashboardButton.ButtonType.ChangeCamera;
        _buttonFinishGameCamera.gearDirection = 1;


        if (_timeActiveBot != null)
        {
            _timeActiveBot.Recorder.Stop();
        }

        await new WaitForSeconds(3f);

        int money = StaticSavePrefs.LoadIntPref(StaticCommunicationChannel.KEY_USER_MONEY);
        int bounty = 0;
        if (_gameType == GameType.TIME)
        {
            if (recorded == null)
            {
                bounty = (2500);
            }
            else
            {
                if (myTime > recorded.topTime)
                {
                    bounty = (5000);
                }
                else
                {
                    bounty = (500);
                }
            }
        }


        FinishGame?.Invoke();

        //finishBG.color
        DOVirtual.Color(new Color(0, 0, 0, 0), new Color(0, 0, 0, 1f), 1f, val => { finishBG.color = val; });

        await new WaitForSeconds(1f);


        if (_gameType == GameType.RACE)
        {
          
            IEnumerable<KeyValuePair<CarRefs, PlayerListControl.playerTimeCar>> temp =
                PlayerListControl.Instance.GetCorrectListPlayer();
            int playerPos = 0;

            float bestTime = temp.ToList()[0].Value.time;
            
            foreach (var (key, value) in temp)
            {
                float carTime = value.time;
                float diff = bestTime - carTime;
                value.time += diff;
            }
            
            temp = PlayerListControl.Instance.GetCorrectListPlayer();
            
            foreach (var (key, value) in temp)
            {
                float carTime = value.time;
                float diff = bestTime - carTime;
                value.time += diff;
                
                if (playerPos >= 2)
                {
                    if (key.IndexCar == myCar.IndexCar)
                    {
                        bounty = 5000 / (playerPos + 1);
                    }
                }
                else
                {
                    bounty = 0;
                }

                playerPos++;
            }
        }
        
        money += bounty;
        StaticSavePrefs.SavePrefs(StaticCommunicationChannel.KEY_USER_MONEY, money);

        await new WaitForSeconds(2f);

        _meshProUGUI.text = "+0";
        _meshProUGUI.gameObject.SetActive(true);
        
        DOVirtual.Float(0, bounty, 1.75f, (value => { _meshProUGUI.text = $"+{((int) value).ToString()}"; }))
            .OnComplete((async () =>
            {
                myTimeFinish.gameObject.SetActive(true);
                float temp = myCar.time;
                DOVirtual.Float(1, temp, 1.75f, (val) =>
                {
                    string minutes = ((int) val / 60).ToString();
                    string seconds = (val % 60).ToString("f2");
                    finishMyTime?.Invoke(minutes + ":" + seconds);
                }).OnComplete((() =>
                {
                    buttons.SetActive(true);
                    
                    EventSystem.current.firstSelectedGameObject = finishButton;
                    finishButton.GetComponent<Button>().Select();
                }));
            }));
    }


    public void RestartGame()
    {
        loadingImage.SetActive(true);
        SceneManager.LoadScene("GamePLay");
    }

    public void PauseUI()
    {
        EventSystem.current.firstSelectedGameObject = pauseButton;
        pauseButton.GetComponent<Button>().Select();
        if (canUsePause)
        {
            inPause = !inPause;
            Time.timeScale = inPause ? 0 : 1;

            if (inPause)
                AudioListener.volume = 0.1f;
            else
                AudioListener.volume = 1f;
            
            pauseUIEvent?.Invoke(inPause);
        }
    }

    public void QuitGame()
    {
        loadingImage.SetActive(true);
        SceneManager.LoadScene("MainMenu");
    }

    public void CircleEnd()
    {
        circleEnds++;
        circlesText?.Invoke($"{circleEnds + 1}/{circlesRace}");
    }
}
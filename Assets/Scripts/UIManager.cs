using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DG.Tweening;
using Rewired;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

enum RaceMode
{
    Circuit,
    TimeTrial
}
public class UIManager : MonoBehaviour
{
    [SerializeField] private List<GameObject> menuGO;

    [SerializeField] private TextMeshProUGUI categoryText;
    [SerializeField] private TextMeshProUGUI loadingText;
    [SerializeField] public TextMeshProUGUI carPrice;
    [SerializeField] public TextMeshProUGUI playerCash;
    
    [SerializeField] private Image loading;
    
    [SerializeField] private Button firstPanelBtnDefault;
    [SerializeField] private Button secondPanelBtnDefault;

    private void Start()
    {
        StaticSavePrefs.SavePrefs(StaticCommunicationChannel.KEY_USER_MONEY, 100000);

        playerCash.text = StaticSavePrefs.LoadIntPref(StaticCommunicationChannel.KEY_USER_MONEY) + "$";
    }

    private void Update()
    {
        if (ReInput.players.GetPlayer(0).GetButtonDown("Back"))
        {
            ClosePanel();
        }
    }
    public void OpenPanel(GameObject go)
    {
        menuGO[^1].SetActive(false);
        menuGO.Add(go);
        go.SetActive(true);
        categoryText.text = go.name;
        secondPanelBtnDefault.Select();
    }

    public void ClosePanel()
    {
        if (menuGO.Count - 1 < 1)
            return;

        menuGO[^1].SetActive(false);
        menuGO.RemoveAt(menuGO.Count - 1);
        menuGO[^1].SetActive(true);
        categoryText.text = menuGO[^1].name;
        firstPanelBtnDefault.Select();

    }

    public void SelectCircuitMode()
    {
        StaticCommunicationChannel.GameType = GameType.RACE;
        StaticCommunicationChannel.raceOpponents = 10;
        LoadScene();
    }
    public void SelectTimeTrialMode()
    {
        StaticCommunicationChannel.GameType = GameType.TIME;
        StaticCommunicationChannel.raceOpponents = 0;
        LoadScene();
    }

    private void LoadScene()
    {
        loadingText.DOFade(1f, .5f);
        loading.DOFade(1f, .5f).OnComplete(() =>
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
        });
    }
}

using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class PlayerInList : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI PosPlayer,NicknamePlayer;
    public CarRefs car;
    private string nicknameText;
    private bool isInit = false;
    private bool change = false;

    public void Init(int pos, string Nickname, CarRefs _car, PlayerListControl.playerTimeCar playerTimeCar)
    {
        if (isInit)
        {
            return;
        }


        car = _car;
        PosPlayer.text = $"{pos}.";
        NicknamePlayer.text = nicknameText = Nickname;
        isInit = true;
    }
    
    public void SetPosition(int index)
    {
        PosPlayer.text = $"{index}.";
    }

    public void ChangeUI(float valueTime)
    {
        change = !change;
        if (change)
        {
            // time car
            string minutes = ((int) valueTime / 60).ToString();
            string seconds = (valueTime % 60).ToString("f2");
            NicknamePlayer.text = minutes + ":" + seconds;
        }
        else
        {
            // name car
            NicknamePlayer.text = nicknameText ;
        }
    }
    
}

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerCheckPoint : MonoBehaviour
{
    [SerializeField][Range(0,5)] private int index;
    [SerializeField] private int circle = 0;
    [SerializeField] private bool isFinish;
    [SerializeField] private bool isCircleCountTrigger;
    [SerializeField] private bool isOnlyTime;

    private bool isFirst = true;
    private int circleTemp = 0;

    public void SetCircle(int circles)
    {
        circle = circles;
    }
    
    private void OnTriggerEnter(Collider other)
    {
        if (other.TryGetComponent(out CarRefs car))
        {

            if (isOnlyTime)
            {
                PlayerListControl.Instance.SetTimePlayer(0,car);
                return;
            }
            
            if (car.IsMine)
            {
                if (!isFinish)
                {
                 
                    if (StaticCommunicationChannel.GameType == GameType.TIME)
                    {
                        GamePlayerContoller.Instance.TriggerCheck(index);
                        this.gameObject.SetActive(false);
                    } else if (StaticCommunicationChannel.GameType == GameType.RACE)
                    {
                        if (isCircleCountTrigger)
                        {
                            if (isFirst)
                            {
                                isFirst = false;
                            }
                            else
                            {
                                GamePlayerContoller.Instance.CircleEnd();
                            }

                            PlayerListControl.Instance.SetTimePlayer(1, car);
                        }
                        else
                        {
                            PlayerListControl.Instance.SetTimePlayer(0,car);
                        }
                        if (car.circle >= circle)
                        {
                            GamePlayerContoller.Instance.TriggerCheck(index);
                        }
                    }
                   
                }
                else
                {
                    GamePlayerContoller.Instance.Finish();
                }
                
            }
            else
            {
                if (isCircleCountTrigger)
                {
                    PlayerListControl.Instance.SetTimePlayer(1,car);
                }
                else
                {
                    PlayerListControl.Instance.SetTimePlayer(0,car);
                }
                
            }
            



            
        }
    }
}

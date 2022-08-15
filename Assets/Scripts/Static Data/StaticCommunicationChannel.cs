using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class StaticCommunicationChannel
{
   public static GameType GameType = GameType.RACE;
   public static int raceOpponents = 4;
   public static int circles = 1;



   public static string KEY_TOP_TIME_BOT = "KEY_TOP_TIME_BOT"; // RCC_Recorder.Recorded 
   public static string KEY_CURRENT_CAR = "KEY_CURRENT_CAR"; // int
   public static string KEY_USER_MONEY = "KEY_USER_MONEY"; // int
   public static string KEY_BOUGHT_CARS = "KEY_BOUGHT_CARS"; //int

}


public enum GameType
{
   RACE = 0,
   TIME = 1
}

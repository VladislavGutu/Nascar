using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class StaticSavePrefs
{
    public static void SavePrefs(string key, int value)
    {
        #if !UNITY_SWITCH
                PlayerPrefs.SetInt(key, value);
        #endif
        #if UNITY_SWITCH
                SaveBridge.SetIntPP(key, value);
        #endif
        PlayerPrefs.Save();
    }
    
    public static void SavePrefs(string key, string value)
    {
        #if !UNITY_SWITCH
                PlayerPrefs.SetString(key, value);
        #endif
        #if UNITY_SWITCH
                SaveBridge.SetStringPP(key, value);
        #endif
        PlayerPrefs.Save();
    }
    
    public static void SavePrefs(string key, float value)
    {
        #if !UNITY_SWITCH
        PlayerPrefs.SetFloat(key, value);
        #endif
        #if UNITY_SWITCH
        SaveBridge.SetFloatPP(key, value);
        #endif

        PlayerPrefs.Save();
    }
    
    public static int LoadIntPref(string key)
    {
        #if !UNITY_SWITCH
            return  PlayerPrefs.GetInt(key, 0);
        #endif
        #if UNITY_SWITCH
            return SaveBridge.GetIntPP(key, 0);

        #endif
    }
    
    public static float LoadFloatPref(string key)
    {
        #if !UNITY_SWITCH
                return  PlayerPrefs.GetFloat(key, 0);
        #endif
        #if UNITY_SWITCH
                return SaveBridge.GetFloatPP(key, 0);
        #endif
    }
    
    public static string LoadStringPref(string key)
    {
        #if !UNITY_SWITCH
                return  PlayerPrefs.GetString(key, "");
        #endif
        #if UNITY_SWITCH
                return SaveBridge.GetStringPP(key, "");
        #endif
    }
    
}
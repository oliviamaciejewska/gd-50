using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {

	public static string currentScene;
	// Use this for initialization
	void Start () {
		
	}
	private AudioSource pickupSoundSource;

	// Update is called once per frame
	void Update () {
		currentScene = SceneManager.GetActiveScene().name;
		if (Input.GetAxis("Submit") == 1) {
			if (currentScene == "Title")
			{	
				SceneManager.LoadScene("Play");
			}
			else
			{
				SceneManager.LoadScene("Title");
			}
		}
	}
}

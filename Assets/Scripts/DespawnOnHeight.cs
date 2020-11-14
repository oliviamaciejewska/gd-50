using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using UnityEngine.SceneManagement;
using UnityEngine;

public class DespawnOnHeight : MonoBehaviour {

	public static Vector3 CameraY;

	
	private AudioSource gameOverSoundSource;
	// Use this for initialization
	void Start()
	{
		gameOverSoundSource = DontDestroy.instance.GetComponents<AudioSource>()[0];
	}

	// Update is called once per frame
	void Update () {
		CameraY = Camera.main.gameObject.transform.position;
		if (CameraY.y < -10)
		{ 
			Destroy(gameOverSoundSource);
			LevelText.level = 1;
			DontDestroy.instance = null;
			SceneManager.LoadScene("GameOver");
		}
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Text))]
public class LevelText : MonoBehaviour {

	public GameObject FPSController;
	private Text text;
	public static int level = 1;
	// Use this for initialization
	void Start () {
		text = GetComponent<Text>();
	}
	
	// Update is called once per frame
	void Update () {

		text.text = "Level:" + level;
	}
}

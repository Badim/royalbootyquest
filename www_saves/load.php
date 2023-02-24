<?php
//header("Content-Type: application/json; encoding=utf-8"); 
	$input = ($_POST);

	$userid = preg_replace("/[^a-zA-Z0-9]+/", "", $input['user_id']);
	$pin = preg_replace("/[^0-9]+/", "", $input['pin']);
	$sid = preg_replace("/[^0-9]+/", "", $input['sid']);

	// echo ("answer:");
	
	if($userid==null){
		echo ("Error(11): no user id");
		return true;
	}
	if($pin=="666"){
		echo ("Error(12): no pin");
		return true;
	}
	
	$filename = "rbq_".$userid."_".$sid."_".$pin.".txt";
	$text = fopen($filename, "r");

	if($text){
		$contents = (fread($text, filesize($filename)));
		fclose($text);
		echo ($contents);
		/*$contents = json_decode($text);
		fclose($filename);
		$handle = fopen("vk_".$input['user_id'].".txt","w+");
		$contents['money'] = $input['money'];
		fwrite($handle,json_encode($contents)); // Записываем
		fclose($handle);*/

	}else{
		
		//echo ("uid:".$userid);
		//echo ("pin:".$pin);
		echo ('Error(13): no such save');
		// $handle2 = fopen($filename,"w+");
		// fclose($handle2);
		// $result = array(); 
		// echo json_encode($result, JSON_FORCE_OBJECT);
	};
	/*
	$input = ($_POST);
	$filename = "vk_".$input['user_id'].".txt";
	$text = fopen($filename, "r");
	if($text)
	{
		$contents = fread($text, filesize($filename));
		fclose($filename);
		echo ($contents);
	}else
	{
		fclose($filename);
		$result = array( 
			'money' => 0,
		   
		); 
		
		
		echo json_encode($result);
	};
	*/
?>
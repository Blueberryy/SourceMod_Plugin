#include <sourcemod>

new Handle:v_enable = INVALID_HANDLE;
new g_sindara[MAXPLAYERS+1];	//���񂾂�t���O

public Plugin:myinfo = 
{
	name = "sindara",
	author = "�s���ޮ�ŰAMG",
	description = "���̃Q�[���͎��񂾂畉��������ȁ[�H",
	version = "1.0",
	url = ""
}

//���m�̃o�O

//�v���O�C���N����
public OnPluginStart(){
	
	//cmd
	RegAdminCmd("sm_reload", Cmd_reload, 0, "�f�o�b�O�R�}���h - �v���O�C���������[�h����");
	
	//cvar
	v_enable = CreateConVar("sm_sindara_enable", "1", "1 = ���񂾂畉���ɂȂ�");
	
	//say�֌W�R�}���h���Ď�
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say2");
	AddCommandListener(Command_Say, "say_team");

	//hook
	HookEvent("player_spawn", OnPlayerSpawned);
	HookEvent("player_death", OnPlayerDeath, EventHookMode_Pre);
	HookEvent("teamplay_round_win", OnRoundEnd, EventHookMode_Pre);
	
	
	HookEvent("teamplay_point_startcapture", OnCap, EventHookMode_Pre);
	HookEvent("controlpoint_starttouch", OnCap, EventHookMode_Pre);

	AddCommandListener(Command_team, "jointeam");
	
}

//�f�o�b�O�p �v���O�C���̃����[�h
public Action:Cmd_reload(client, args){
	ServerCommand("sm plugins reload sindara");
	ReplyToCommand(client,"sindara�v���O�C���������[�h���܂����B");
	return false;
}

public OnCap(Handle:event, const String:name[], bool:dontBroadcast){

	return Plugin_Handled;
	
}



//�����ضޗp
public Action:Command_Say(client, const String:command[], argc){
	//say�R�}���h�̓��e���m�� argc�͕K���P�isay�R�}���h�͔����S�Ă��P��Ƃ��đ���悤���j

	new String:strSay[192];
	GetCmdArg(1,strSay, sizeof(strSay));
	
	if(strcmp(strSay,"sindara",true) == 0 && GetConVarInt(v_enable) == 1){

		//���񂾂�t���O�𗧂Ă�
		if(g_sindara[client] == 0){
			g_sindara[client] = 1;
		}
	}else if(strcmp(strSay,"sinanai",true) == 0){
		g_sindara[client] = 0;
	}
}
	
//HookEvent ���E���h�I����
public OnRoundEnd(Handle:event, const String:name[], bool:dontBroadcast){
	
	new i;
	for(i = 0 ; i <= MAXPLAYERS ; i++){
		g_sindara[i] = 0;
	}
}


//HookEvent �X�|�[���Ď�
public OnPlayerSpawned(Handle:event, const String:name[], bool:dontBroadcast){

	//get player index
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(g_sindara[client] != 0){
		FakeClientCommandEx(client,"kill");
	}
}

//HookEvent ���S�m�F
public OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast){

	//get player index
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(g_sindara[client] == 1){
		g_sindara[client] = 2;
		FakeClientCommandEx(client,"say sinda");
	}
	else if(g_sindara[client] == 2){
		//SetEventInt(event,"inflictor_entindex",0);
		//SetEventInt(event,"attacker",0);
		SetEventString(event,"weapon","eternal_reward");
		SetEventString(event,"weapon_logclassname","eternal_reward");
		SetEventInt(event,"weaponid",7);
		//SetEventInt(event,"damagebits",135270528);
		SetEventInt(event,"customkill",2);
		//SetEventInt(event,"death_flags",1); //�����t���O
		SetEventInt(event,"silent_kill",1);
		SetEventInt(event,"crit_type",2);
	
		new TF2GameRulesEntity = FindEntityByClassname(-1, "tf_gamerules");
		if(TF2GameRulesEntity == -1){
			PrintToServer("[sindara]ERROR no entity");
		}
		
		
	}
}
	
//�N���C�A���g�ؒf��
public OnClientDisconnect(client){
	g_sindara[client] = 0;
}
	
//�`�[���ύX�Ď�(�ϐ�))
public Action:Command_team(client, const String:command[], argc){
	
	//�ϐ�ɓ������烊�Z�b�g
	
	//red,blue,spectate,auto
	new String:strjoin[10];
	GetCmdArg(1,strjoin, sizeof(strjoin));
	
	//�ϐ�ɓ�����
	if(strcmp(strjoin,"spectate",true) == 0){
		g_sindara[client] = 0;
	}
}

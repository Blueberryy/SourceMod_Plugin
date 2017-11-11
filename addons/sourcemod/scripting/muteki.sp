#include <sourcemod>

new g_flag[MAXPLAYERS+1];	//���G���[�h�t���O

public Plugin:myinfo = 
{
	name = "muteki",
	author = "�s���ޮ�ŰAMG",
	description = "�_���[�W�����v���O�C��",
	version = "1.0",
	url = ""
}


//�v���O�C���N����
public OnPluginStart(){
	
	//cmd
	RegAdminCmd("sm_muteki", Cmd_muteki, ADMFLAG_KICK, "sm_muteki <name/id> - �w��̃v���C���[�𖳓G�ɂ���");
	//RegAdminCmd("sm_muteki", Cmd_muteki, 0, "sm_muteki <name/id> - �w��̃v���C���[�𖳓G�ɂ���");
	RegAdminCmd("sm_reload", Cmd_reload, 0, "�f�o�b�O�R�}���h - �v���O�C���������[�h����");
	
	//hook
	HookEvent("player_spawn", OnPlayerSpawned);

	PrintToServer("�_���[�W�����v���O�C���N��");
	
}

//�f�o�b�O�p �v���O�C���̃����[�h
public Action:Cmd_reload(client, args){
	ServerCommand("sm plugins reload muteki");
	ReplyToCommand(client,"�v���O�C���������[�h���܂����B");
	return false;
}

//sm_muteki���s��
public Action:Cmd_muteki(client, args)
{
	
	//�������Ȃ��ꍇ
	if(args == 0)
	{
		ReplyToCommand(client,"!muteki <name/id> - �w��̃v���C���[�𖳓G�ɂ���");
		return false;
	}
	
	//�Ώۂ̖��O���m��
	new String:strTarget[MAX_NAME_LENGTH];
	GetCmdArgString(strTarget, sizeof(strTarget));
	
	//���O����N���C�A���g��T���c
	char target_name[MAX_NAME_LENGTH];
	int target_list[MAXPLAYERS];
	int target_count;
	bool tn_is_ml;
	
	if((target_count = ProcessTargetString(
		strTarget,				//�������閼�O
		0,						//�s���@�Ǘ��җ��݁H
		target_list,			//���������Ώۂ̃��X�g�H �N���C�A���gindex��z��ŕԂ��Ă���ۂ��c�H
		MAXPLAYERS,				//���������Ώۂ̐��̍ő�l(���)
		0,						//�t�B���^�[�t���O
		target_name,			//���������Ώۂ�"�O���[�v��"���O(ALL PLAYERS ��)
		sizeof(target_name),	//���O�o�b�t�@�̃T�C�Y
		tn_is_ml)) <= 0)
	{
		//�ΏۂȂ�
		PrintToServer("No matching client");
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	//�Ώۂ���
	new i;
	bool boolFlag = false;
	
	for(i = 0;i < target_count;i++){
		//�Ώۂ̒��ɖ��G�t���O�������ĂȂ��l�͋��邩�H
		if(g_flag[target_list[i]] == 0){
			boolFlag = true;
			break;
		}
	}
	
	//1�l�ł��Ώۂɖ��G����Ȃ��l������ꍇ�A�S���𖳓G�ɂ���
	//�S�������G�Ȃ�A�S�����G����������
	for(i = 0;i < target_count;i++){
		//���G������
		muteki(target_list[i],boolFlag);
	}
	
	
	if(target_count == 1)
	{
		if(boolFlag){
			PrintToChatAll("%s�𖳓G�ɂ��܂����B",strTarget);
		}
		else{
			PrintToChatAll("%s�̖��G���������܂����B",strTarget);
		}
	}
	else
	{
		if(boolFlag){
			PrintToChatAll("%s�𖳓G�ɂ��܂����B",target_name);
		}
		else{
			PrintToChatAll("%s�̖��G���������܂����B",target_name);
		}
	}
	
	return true;
	
}

//HookEvent
public OnPlayerSpawned(Handle:event, const String:name[], bool:dontBroadcast){

	//get player index
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	//���G�t���O�������Ă���ꍇ�̂�
	if(g_flag[client] == 1){
		muteki(client,true);
	}

	return false;
}

public muteki(int client, bool boolFlag){

	/*�悭�킩��Ȃ��������R�[�h���
	//m_takedame�̒l��0�`2�̊ԂŕύX����@�Ō��1�͏������݃o�C�g���Ȃ̂�1
	SetEntProp(client, Prop_Data, "m_takedamage", 0, 1);	//God
	SetEntProp(client, Prop_Data, "m_takedamage", 1, 1);	//Buddha
	SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);	//Mortal
	*/
	
	//�N���C�A���g�����m�F
	if (client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && IsPlayerAlive(client)){

		if(boolFlag){
			g_flag[client] = 1;
			SetEntProp(client, Prop_Data, "m_takedamage", 1, 1);	//Buddha
		}
		else{
			g_flag[client] = 0;
			SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);	//Mortal
		}
	
	}
}

public OnClientDisconnect(client){
	//�v���C���[�ؒf���A���̃v���C���[�̐ݒ��������
	g_flag[client] = 0;
}
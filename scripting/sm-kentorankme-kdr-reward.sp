#include <kento_rankme/rankme>

int g_iDieCount[MAXPLAYERS + 1];
int g_iKillCount[MAXPLAYERS + 1];
int g_iHeadshotCount[MAXPLAYERS + 1];

public Plugin myinfo =
{
	name	= "(DF) KentoRANKME KDR reward",
	author	= "daffyy",
	version = "1.0",
	url		= "https://github.com/daffyyyy/sm-KentoRANKME-KDR-reward"
};

public void OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("cs_win_panel_match", Event_MatchEnd);
}

public void OnClientPutInServer(int client)
{
	g_iDieCount[client]		 = 0;
	g_iKillCount[client]	 = 0;
	g_iHeadshotCount[client] = 0;
}

public Action Event_MatchEnd(Event event, const char[] name, bool bDontBroadcast)
{
	for (int i = 0; i <= MAXPLAYERS; i++)
	{
		if (!IsValidClient(i)) continue;

		if (g_iKillCount[i] < 10 || g_iDieCount[i] < 5)
			return Plugin_Continue;

		float fKDR = (float(g_iKillCount[i]) / float(g_iDieCount[i])) + float(g_iHeadshotCount[i] / 2);

		if (fKDR >= 1.1 && fKDR <= 1.25)	// TODO: PLUS
		{
			RankMe_GivePoint(i, 1, "KDR", false, false);
		}
		else if (fKDR >= 1.35 && fKDR <= 1.45)
		{
			RankMe_GivePoint(i, 1, "KDR", false, false);
		}
		else if (fKDR >= 1.5 && fKDR <= 1.75)
		{
			RankMe_GivePoint(i, 2, "KDR", false, false);
		}
		else if (fKDR >= 1.8 && fKDR <= 1.9)
		{
			RankMe_GivePoint(i, 4, "KDR", false, false);
		}
		else if (fKDR >= 2.0 && fKDR <= 2.15)
		{
			RankMe_GivePoint(i, 5, "KDR", false, false);
		}
		else if (fKDR >= 2.20 && fKDR <= 2.40)
		{
			RankMe_GivePoint(i, 6, "KDR", false, false);
		}
		else if (fKDR >= 2.20)
		{
			RankMe_GivePoint(i, 8, "KDR", false, false);
		}
	}
	return Plugin_Continue;
}

public Action Event_PlayerDeath(Event event, const char[] name, bool bDontBroadcast)
{
	int	 attacker = GetClientOfUserId(event.GetInt("attacker"));
	int	 assister = GetClientOfUserId(event.GetInt("assister"));
	int	 client	  = GetClientOfUserId(event.GetInt("userid"));
	bool headshot = event.GetBool("headshot", false);

	if (!IsValidClient(attacker) || !IsValidClient(client) || attacker == client || assister == client)
		return Plugin_Continue;

	if (headshot)
	{
		g_iHeadshotCount[attacker]++;
	}

	g_iKillCount[attacker]++;
	g_iDieCount[client]++;

	return Plugin_Continue;
}

stock bool IsValidClient(int client)
{
	if (client <= 0) return false;
	if (client > MaxClients) return false;
	if (!IsClientConnected(client)) return false;
	if (IsFakeClient(client)) return false;
	return IsClientInGame(client);
}
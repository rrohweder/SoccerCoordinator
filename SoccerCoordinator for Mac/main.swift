// TODO:
// - need to set teams[teamIndex]["AvgHeight"] 




//
//  main.swift
//  SoccerCoordinator for Mac
//
//  Created by Roger Rohweder on 9/26/16.
//  Copyright © 2016 Roger Rohweder. All rights reserved.
//

// Soccer Coordinator Exercise

/*
 Main logic:
 
 Load Player Data
 Load Team Data
 Assign Players To Teams
 Report Team Balance
 Print Team Rosters
 Create Player Selection Notices
 
*/

/* data collection requirements:
  Array of Dictionaries for Entire League
  Array of Dictionaries for each of three teams
  Dictionary for each player
*/

// array of dictionaries containing every player
var leagueMembers: [Dictionary<String,String>] = []
 
// var players: [String: String] = [:]
//    "PlayerName"
//    "PlayerHeight"
//    "IsExperienced"
//    "Guardians"
//    "Team"

var teams: [Dictionary<String,String>] = []
//    "TeamName"
//    "NumPlayers"
//    "SumOfHeights"
//    "AvgHeight"
//    "FirstPractice"

/*
   would like to have used arrays of objects (or at least structs) for players and teams.
*/

func AddPlayer(playerName: String, playerHeight: String, isExperienced: String, guardians: String) {
    
    // would like to use a struct here, so I could mix types
    let player = [
        "PlayerName" : playerName,
        "PlayerHeight" : playerHeight,
        "IsExperienced" : isExperienced,
        "Guardians" : guardians,
        "Team" : "unassigned"
    ]
    leagueMembers.append(player)
}

func LoadPlayerData() {
    
    AddPlayer(playerName: "Joe Smith",	playerHeight: "42", isExperienced: "YES",
              guardians: "Jim and Jan Smith")
    
    AddPlayer(playerName: "Jill Tanner", playerHeight: "36", isExperienced: "YES",
              guardians: "Clara Tanner")
    
    AddPlayer(playerName: "Bill Bon", playerHeight: "43", isExperienced: "YES",
              guardians: "Sara and Jenny Bon")
    
    AddPlayer(playerName: "Eva Gordon", playerHeight: "45", isExperienced: "NO",
              guardians: "Wendy and Mike Gordon")
    
    AddPlayer(playerName: "Matt Gill", playerHeight: "40", isExperienced: "NO",
              guardians: "Charles and Sylvia Gill")
    
    AddPlayer(playerName: "Kimmy Stein", playerHeight: "41",isExperienced: "NO",
              guardians: "Bill and Hillary Stein")
    
    AddPlayer(playerName: "Sammy Adams", playerHeight: "45", isExperienced: "NO",
              guardians: "Jeff Adams")
    
    AddPlayer(playerName: "Karl Saygan", playerHeight: "42", isExperienced: "YES",
              guardians: "Heather Bledsoe")
    
    AddPlayer(playerName: "Suzane Greenberg", playerHeight: "44", isExperienced: "YES", guardians: "Henrietta Dumas")
    
    AddPlayer(playerName: "Sal Dali", playerHeight: "41", isExperienced: "NO",
              guardians: "Gala Dali")
    
    AddPlayer(playerName: "Joe Kavalier", playerHeight: "39", isExperienced: "NO",
              guardians: "Sam and Elaine Kavalier")
    
    AddPlayer(playerName: "Ben Finkelstein", playerHeight: "44", isExperienced: "NO", guardians: "Aaron and Jill Finkelstein")
    
    AddPlayer(playerName: "Diego Soto", playerHeight:	"41", isExperienced: "YES",
              guardians: "Robin and Sarika Soto")
    
    AddPlayer(playerName: "Chloe Alaska", playerHeight: "47", isExperienced: "NO",
              guardians: "David and Jamie Alaska")
    
    AddPlayer(playerName: "Arnold Willis", playerHeight: "43", isExperienced: "NO",
              guardians: "Claire Willis")
    
    AddPlayer(playerName: "Phillip Helm", playerHeight: "44", isExperienced: "YES",
              guardians: "Thomas Helm and Eva Jones")
    
    AddPlayer(playerName: "Les Clay", playerHeight: "42", isExperienced: "YES",
              guardians: "Wynonna Brown")
    
    AddPlayer(playerName: "Herschel Krustofski", playerHeight: "45",isExperienced: "YES", guardians: "Hyman and Rachel Krustofski")
    return
}

func AddTeam(teamName: String, firstPracticeDate: String) {
    let aTeam = [
        "TeamName" : teamName,
        "NumPlayers" : "0",
        "SumOfHeights" : "0",
        "AvgHeight" : "0.0",
        "FirstPractice" : firstPracticeDate
    ]
    teams.append(aTeam)
}

func LoadTeamData() {
    AddTeam(teamName : "Sharks", firstPracticeDate: "March 17, 3:00 PM")
    AddTeam(teamName : "Raptors", firstPracticeDate: "March 18, 1:00 PM" )
    AddTeam(teamName : "Dragons", firstPracticeDate: "March 17, 1:00 PM")
}

func SortPlayersForBalance() {
    /*
     the following used guidance from http://stackoverflow.com/questions/24593867/sort-an-array-of-dictionaries-in-swift
     */
    
    leagueMembers.sort {
        item1, item2 in
        
        let ise1 = item1["IsExperienced"]
        let ise2 = item2["IsExperienced"]
        let ph1:Int? =  Int(item1["PlayerHeight"]!)
        let ph2:Int? =  Int(item2["PlayerHeight"]!)
 
        if ise1 == "YES"  {
            if ise2 == "YES" {
                if ph1! >= ph2! {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            if ise2 == "YES" {
                return false
            } else {
                if ph1! >= ph2! {
                    return true
                } else {
                    return false
                }
            }
            
        }
    }
}

func GetLeagueArrayIndexByName(name: String) -> Int {
    var targetIndex: Int = 0
    for playerDictionary in leagueMembers {
        if playerDictionary["PlayerName"] == name {
            return targetIndex
        } else {
            targetIndex = targetIndex + 1
        }
    }
    return -1
}

func GetTeamArrayIndexByName(name: String) -> Int {
    var targetIndex: Int = 0
    for teamDictionary in teams {
        if teamDictionary["TeamName"] == name {
            return targetIndex
        } else {
            targetIndex = targetIndex + 1
        }
    }
    return -1
}


// function to set the teamIndex the the next shortest team by avg height
// for each round

var teamIndex: Int = 0

func nextTeam() {
    if teamIndex == teams.count - 1 {

        // (re-)calculate average height
        var tmavg: Float = 0.0
        for tm in teams {
            tmavg = ( Float(tm["SumOfHeights"]!)! / Float(tm["NumPlayers"]!)! )
            teams[GetTeamArrayIndexByName(name: tm["TeamName"]!)]["AvgHeight"] = String(tmavg)
        }
        
        // sort teams by Average Height, descending
        teams.sort {
            item1, item2 in
            let ta1:Float? =  Float(item1["AvgHeight"]!)
            let ta2:Float? =  Float(item2["AvgHeight"]!)
            if ta1! <= ta2! {
                return true
            } else {
                return false
            }
        }
            
        teamIndex = 0

/* used to confirm it was working
        print("distrib pass, teams sorted by avg height ")
        for x in 0...teams.count-1 {
            print("\(teams[x]["TeamName"]!): \(teams[x]["AvgHeight"]!)")
        }
*/
    } else {
        teamIndex = teamIndex + 1
    }
    return
}

/*
    calculate the avg height for each team after each round of assignment, then sort teams 
    by avg ht desc, and assign players to teams in that order.
 */

func AssignPlayersToTeams() {
    SortPlayersForBalance()  // sort players
    print("All players, sorted by experience, then height:")
    for p in leagueMembers {
        print("\(p["PlayerName"]!), \(p["IsExperienced"]!), \(p["PlayerHeight"]!)")
    }
    print("\n")
    
    // assign each player to a team
    for player in leagueMembers {
        let pnm = player["PlayerName"]
        let pht: Int = Int(player["PlayerHeight"]!)!
        let tm = teams[teamIndex]["TeamName"]
        
        leagueMembers[GetLeagueArrayIndexByName(name: pnm!)]["Team"] = tm

        teams[teamIndex]["NumPlayers"] =
            String(Int(teams[teamIndex]["NumPlayers"]!)! + 1)

        teams[teamIndex]["SumOfHeights"] =
            String(Int(teams[teamIndex]["SumOfHeights"]!)! + pht)
        nextTeam()
     }
    nextTeam()  // with new architectur, do I still need to call one more time to get the last set of assigned players counted.
}

func GetMinAvgHeight() -> Float {
    var newmin: Float = 999.9
    for t in teams {
        if Float(t["AvgHeight"]!)! < newmin {
            newmin = Float(t["AvgHeight"]!)!
        }
    }
    return newmin
}

func GetMaxAvgHeight() -> Float {
    var newmax: Float = 0.0
    for t in teams {
        if Float(t["AvgHeight"]!)! > newmax {
            newmax = Float(t["AvgHeight"]!)!
        }
    }
    return newmax
}

func AnalyzeTeamBalance() {
 
    // report team average height
    print("Team stats:")
    for tm in teams {
        print("\(tm["TeamName"]!) height sum= \(tm["SumOfHeights"]!), player count= \(tm["NumPlayers"]!), and average= \(tm["AvgHeight"]!)")
    }
    print("\n")
    
    let tmMax = GetMaxAvgHeight()
    let tmMin = GetMinAvgHeight()
    
    if (tmMax - tmMin) > 1.5 {
        print("Teams are not balanced", terminator:" ")
    } else {
        print("Teams are well balanced", terminator:" ")
    }
    print(" - average height delta is \(tmMax - tmMin)! \n")
    
    return
}

func getGard(player: String) -> String {
    for pdic in leagueMembers {
        if pdic["PlayerName"] == player {
            return pdic["Guardians"]!
        }
    }
    return ""
}

func PrintTeamRoster(TeamName: String) {
    print("\(TeamName) Roster list:\n")
    for player in leagueMembers {
        if player["Team"] == TeamName {
            print("Guardians: \(player["Guardians"]!)\tPlayer: \(player["PlayerName"]!)")
        }
    }
    print("\n")
}

func SendPlayerSelectionNotices() {
/* specification:
     Provide logic that prints a personalized letter to the guardians specifying: 
     the player’s name, guardians' names, team name, and date/time of their first team practice. 
     The letters should be visible when code is placed in a XCode Playground or run in an 
     XCode project.
*/
    
    for player in leagueMembers {
        print("---------------")
        print("Dear \(player["Guardians"]!),\n")
        
        print("Congratulations on the selection of \(player["PlayerName"]!) by the \(player["Team"]!) Team.")
        
        print("Please make sure to put the team's first practice on \(teams[GetTeamArrayIndexByName(name: player["Team"]!)]["FirstPractice"]!) on your calendar.\n")
            
        print("For your reference, here is the complete list of players selected by the \(player["Team"]!):\n\n")
        
        PrintTeamRoster(TeamName: player["Team"]!)
    }
}

LoadPlayerData()
LoadTeamData()
AssignPlayersToTeams()

print("Player assignments to Teams:")
for tms in teams.sorted(by: { $0["TeamName"]! < $1["TeamName"]! })
{
    for player in leagueMembers.sorted(by: {$0["PlayerName"]! < $1["PlayerName"]!}) {
        if player["Team"] == tms["TeamName"] {
            print("\(tms["TeamName"]!)\t\(player["PlayerName"]!)")
        }
    }
    print(" ")
}
print("\n")

AnalyzeTeamBalance()
// PrintTeamRosters()
SendPlayerSelectionNotices()


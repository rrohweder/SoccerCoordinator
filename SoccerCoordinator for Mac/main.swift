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
 
 Fetch Player Data
 Fetch Team Data
 Assign Players To Teams
 report Report Team Balance
 Print Team Rosters
 Send Player Selection Notices
 
*/

// array of dictionaries of meta-data for each player.
var playerArray: [Dictionary<String,String>] = []

// array of teams
var teamArray: [String] = []  // teamNames

var firstPractice: [String:String] = ["Dragons":"March 17, 1:00 PM", "Sharks":"March 17, 3:00 PM",
"Raptors":"March 18, 1:00 PM"]

// dictionary to hold player->team mapping
var playerAssignments = [String: String]()  // playerName, teamName

// aggregate values for each team
var teamHeightSums = [String: Int]()
var teamPlayersCount = [String: Int]()
var teamHeightAvg = [String: Float]()
var teamsByHeight = [String]()

/*
   would like to have used arrays of objects (or at least structs) for players and teams.
*/

func AddPlayer(playerName: String, playerHeight: String, isExperienced: String, guardians: String) {
    
    // would like to use a struct here, so I could mix types
    let player = [
        "PlayerName" : playerName,
        "PlayerHeight" : playerHeight,
        "IsExperienced" : isExperienced,
        "Guardians" : guardians
    ]
    playerArray.append(player)
}

func FetchPlayerData() -> [Dictionary<String,String>] {  /* I think this output is correct */
    
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
    return playerArray
}

func FetchTeamData() -> [String] {
    teamArray.append("Dragons")
    teamArray.append("Sharks")
    teamArray.append("Raptors")
    return teamArray
}

func SortPlayersForBalance() {
    /*
     the following used guidance from http://stackoverflow.com/questions/24593867/sort-an-array-of-dictionaries-in-swift
     */
    
    playerArray.sort {
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


/* function to return next team name by avg height, ascending for each round */
var teamIndex: Int = 0

func nextTeam() -> String {
    var teamToReturn: String
    if teamIndex >= teamsByHeight.count {
        // clear for re-calc
        for tm in teamArray {
            teamPlayersCount[tm] = 0
            teamHeightSums[tm] = 0
        }

        // aggregate info about each team
        for playerDict in playerArray {
            let player = playerDict["PlayerName"]
            let height = Int(playerDict["PlayerHeight"]!)
            let team = playerAssignments[player!]
            if (team != nil) {
                teamPlayersCount[team!]! += 1
                teamHeightSums[team!] = teamHeightSums[team!]! + height!
            }
        }
        
        var tmavg: Float = 0.0
        for tm in teamArray {
            tmavg = ( Float(teamHeightSums[tm]!) / Float(teamPlayersCount[tm]!) )
            teamHeightAvg[tm] = tmavg
        }
        
        // get
        var newIndex: Int = 0
        for et in teamHeightAvg.sorted(by: {$0.value < $1.value}) {
            teamsByHeight[newIndex] = et.key
            newIndex = newIndex + 1
        }
        teamIndex = 0

/* used to confirm it was working
        print("teams sorted by avg height ")
        for x in 0...2 {
            print("\(teamsByHeight[x]): \(teamHeightAvg[teamsByHeight[x]])")
        }
*/
    }
    
    teamToReturn = teamsByHeight[teamIndex]
    teamIndex = teamIndex + 1
    return teamToReturn
}

/*
    calculate the avg height for each team after each round of assignment, then sort teams 
    by avg ht desc, and assign players to teams in that order.
 */

func AssignPlayersToTeams() -> [String: String] {
    for tm in teamArray {
        teamPlayersCount[tm] = 0
        teamHeightSums[tm] = 0
    }
    SortPlayersForBalance()  // sort players
    print("All players, sorted by experience, then height:")
    for p in playerArray {
        print("\(p["PlayerName"]!), \(p["IsExperienced"]!), \(p["PlayerHeight"]!)")
    }
    print("\n")
    
    var teamsHeightOrder: [String:Any] = [:]
    var teamMetadata: [String:Int] = [:]
    
    for t in teamArray {
        teamMetadata["Count"] = 0
        teamMetadata["Sum"] = 0
        teamMetadata["Avg"] = 0

        teamsHeightOrder[t] = teamMetadata
    }

    // assign each player to a team
    for player in playerArray {
        let pnm = player["PlayerName"]
        playerAssignments[pnm!] = nextTeam()
     }
    nextTeam()  // call one more time to get the last set of assigned players counted.
    return playerAssignments
}

func AnalyzeTeamBalance() {
 
    // report team average height
    var tmavg: Float = 0.0
    print("Team stats:")
    for tm in teamArray {
        tmavg = ( Float(teamHeightSums[tm]!) / Float(teamPlayersCount[tm]!) )
        print("\(tm) height sum= \(teamHeightSums[tm]!), player count= \(teamPlayersCount[tm]!), and average= \(tmavg)")
    }
    print("\n")
    
    if (teamHeightAvg.values.max()! - teamHeightAvg.values.min()!) > 1.5 {
        print("Teams are not balanced - height delta is \(teamHeightAvg.values.max()! - teamHeightAvg.values.min()!)")
    } else {
        print("Teams are well balanced - height delta is \(teamHeightAvg.values.max()! - teamHeightAvg.values.min()!)")
    }
    print("\n")
    
    return
}

func getGard(player: String) -> String {
    for pdic in playerArray {
        if pdic["PlayerName"] == player {
            return pdic["Guardians"]!
        }
    }
    return ""
}

func PrintTeamRoster(TeamName: String) {
    print("\(TeamName) Roster list:\n")
    for player in playerAssignments {
        if player.value == TeamName {
            print("Guardians: \(getGard(player: player.key))\tPlayer: \(player.key)")
            
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
    
    for player in playerArray {
        print("---------------")
        print("Dear \(player["Guardians"]!),\n")
        print("Congratulations on the selection of \(player["PlayerName"]!) by the \(  playerAssignments[player["PlayerName"]!]!) Team.")
        print("Please make sure to put the team's first practice on \(firstPractice[playerAssignments[player["PlayerName"]!]!]!) on your calendar.\n")
        print("For your reference, here is the complete list of players selected by the \(playerAssignments[player["PlayerName"]!]!):\n\n")
        
        PrintTeamRoster(TeamName: playerAssignments[player["PlayerName"]!]!)
    }
}

let thePlayers: [Dictionary<String,String>] = FetchPlayerData()
let theTeams = FetchTeamData()

 for t in theTeams {
    teamsByHeight.append(t)
 }
let theAssignments = AssignPlayersToTeams()

print("Player assignments to Teams:")
for ta in theAssignments {
    print("key=\(ta.key), value=\(ta.value)")
}
print("\n")

AnalyzeTeamBalance()
// PrintTeamRosters()
SendPlayerSelectionNotices()


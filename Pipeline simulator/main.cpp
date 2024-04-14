#include <iostream>
#include <fstream>
#include <map>
#include <vector>
#include <string>
#include <iterator>
#include <iomanip>


using namespace std;

int pc = 0;
int branches = 0; //when calculating the percentage, make sure branches != 0
int mispredictions = 0;
map<int, int16_t> mem;
map<string, pair<int, int>> stations;
int16_t reg[8] = {0,0,0,0,0,0,0,0};

class Inst
{
public :
	string inst_name, inst_station;
	int rs_1, rs_2, rd, offeset, cycle_span, issue, exec_start, exec_end, wb, pc;
    bool b_flag;
	Inst ()
	{
		this->rd = 0;
		this->rs_1 = 0;
		this->rs_2 = 0;
		this->offeset = 0;
		this->cycle_span = 0;
        this->issue = 0;
		this->exec_start = -1;
		this->exec_end = -1;
		this->wb = 0;
        this->pc = 0;
		this->b_flag = false;
		this->inst_name = "";
		this->inst_name = "";
	}

	Inst(string _inst_name, string _inst_station, int _rs_1, int _rs_2, int _rd, int _offeset, int _cycle_span, int _issue, 
	int _exec_start, int _exec_end, int _wb, int _pc, bool _b_flag)
	{
		set(_inst_name, _inst_station, _rs_1, _rs_2, _rd, _offeset, _cycle_span, _issue, _exec_start, _exec_end, _wb, _pc, _b_flag);
	}

	void set(string _inst_name, string _inst_station, int _rs_1, int _rs_2, int _rd, int _offeset, int _cycle_span, int _issue, 
	int _exec_start, int _exec_end, int _wb, int _pc, bool _b_flag)
	{
		inst_name = _inst_name;
		inst_station = _inst_station;
		rs_1 = _rs_1;
		rs_2 = _rs_2;
		rd = _rd;
		offeset = _offeset;
		cycle_span = _cycle_span;
		issue = _issue;
		exec_start = _exec_start;
		exec_end = _exec_end;
		wb = _wb;
        pc = _pc;
		b_flag = _b_flag;
	}
	
};

void Print(vector<Inst> inst)
{
	for (int i = 0; i < inst.size(); i++)
	{
		cout << "The instruction name :" << inst[i].inst_name << endl;
		cout << "The instruction rd :" << inst[i].rd << endl;
		cout << "The instruction rs1 :" << inst[i].rs_1 << endl;
		cout << "The instruction rs2 :" << inst[i].rs_2 << endl;
		cout << "The instruction offeset :" << inst[i].offeset << endl;

	}
}

map<string, int> labels;
vector<string> separate(string line) {
	vector<string> words;
	string a = "";
	for (int i = 0; i < line.size(); i++) {
		if (line[i] != ' ' && line[i] != ',' && line[i] != ':' && line[i] != '\t') 
			a += line[i];
		else  {
		 words.push_back(a);
			a = "";
		}
	}
	if (a.size()) words.push_back(a);

	return words;
}


pair<int, int> getRegImm(string s) {
    int imm, reg;
    for (int i = 0; i < s.size(); i++) {
        if (s[i] == '(') {
            imm = stoi(s.substr(0, i));
            reg = (int)s[i+2] - '0';
        }
    }
    return {reg, imm};
}

vector <Inst> FillFromFile(string filename)
{
	vector<string> lines;
	ifstream inputFile(filename);
	if (!inputFile.is_open())
	{
		cout << "The file cannot be opened" << endl;
		exit(1);
	}
	string line;
	int counter = 0;
	while (getline(inputFile, line, '\n'))
	{
		counter++;
	}
	vector <Inst> inst(counter);
	counter = 0;
	inputFile.close();
	inputFile.open(filename);
	while (getline(inputFile,line, '\n'))
	{	
		lines = separate(line);
        for (int x=0; x<lines[0].length(); x++)
            lines[0][x] = tolower(lines[0][x]);

		if (lines[0] == "add" || lines[0] == "div" || lines[0] == "nand" ) {
			inst[counter].set(lines[0], lines[0], (int) lines[2][1] - '0', (int) lines[3][1] - '0', (int) lines[1][1] - '0', 0, 0, 0, 0, 0, 0, 0, false);
		}
		else if (lines[0] == "addi") {
			inst[counter].set(lines[0], "add", (int) lines[2][1] - '0', -1, (int) lines[1][1] - '0', stoi(lines[3]), 0, 0, 0, 0, 0, 0, false);
		}
		else if (lines[0] == "load") {
			int rs_1_value, offeset_value;
			tie(rs_1_value, offeset_value) = getRegImm(lines[2]);
			inst[counter].set(lines[0], lines[0], rs_1_value, -1, (int) lines[1][1] - '0', offeset_value, 0, 0, 0, 0, 0, 0, false);
		}
		else if (lines[0] == "store") {
			int rs_2_value, offeset_value;
			tie(rs_2_value, offeset_value) = getRegImm(lines[2]);
			inst[counter].set(lines[0], lines[0], (int) lines[1][1] - '0', rs_2_value, -1, offeset_value, 0, 0, 0, 0, 0, 0, false);			
		}
		else if (lines[0] == "bne") {
			inst[counter].set(lines[0], lines[0], (int) lines[1][1] - '0', (int) lines[2][1] - '0', -1, stoi(lines[3]), 0, 0, 0, 0, 0, 0, false);
		}
		else if (lines[0] == "call") {
			inst[counter].set(lines[0], lines[0], -1, -1, 1, stoi(lines[1]), 0, 0, 0, 0, 0, 0, false);
		}
		else if (lines[0] == "ret") {
			inst[counter].set(lines[0], "call", 1, -1, -1, 0, 0, 0, 0, 0, 0, 0, false);
		}

		counter++;
	}
	
	
	inputFile.close();
	return inst;
}

void FillFromFile_data(string filename)
{
	vector<string> lines;
	ifstream inputFile(filename);
	if (!inputFile.is_open())
	{
		cout << "The file cannot be opened" << endl;
		exit(1);
	}
	string line;
	int counter = 0;
	while (getline(inputFile, line, '\n'))
	{
        lines = separate(line);
		mem[stoi(lines[0])] = stoi(lines[1]);
	}
}

void FillFromFile_hardware(string filename)
{
	vector<string> lines;
	ifstream inputFile(filename);
	if (!inputFile.is_open())
	{
		cout << "The file cannot be opened" << endl;
		exit(1);
	}
	string line;
	int counter = 0;
	while (getline(inputFile, line, '\n'))
	{
        lines = separate(line);
        // For add/addi and call/ret, as they have the same reservation station
        for(int i=0; i<lines[0].length(); ++i){
            if(lines[0][i] == '/'){
                lines[0] = lines[0].substr(0, i);
                break;
            }
        }

        stations[lines[0]] = {stoi(lines[1]), stoi(lines[2])};
	}
}

//Excution
void operation_excution(Inst& inst){
    if(inst.inst_name=="add" && inst.rd != 0) {
        reg[inst.rd]=reg[inst.rs_1]+reg[inst.rs_2];
    }
    else if(inst.inst_name == "addi" && inst.rd != 0) {
        reg[inst.rd]=reg[inst.rs_1]+inst.offeset;
    }
    else if(inst.inst_name=="nand" && inst.rd != 0) {
        reg[inst.rd]=~(reg[inst.rs_1]&reg[inst.rs_2]);//
    }
    else if(inst.inst_name=="div" && inst.rd != 0) {
        reg[inst.rd]=reg[inst.rs_1]/reg[inst.rs_2];
    }
    else if(inst.inst_name=="bne") {
        if(reg[inst.rs_1]!=reg[inst.rs_2]){
            pc = inst.pc + inst.offeset + 1;
            inst.b_flag = true;
        }
        else inst.b_flag = false;
    }
    else if(inst.inst_name=="store") {
        mem[(inst.offeset+reg[inst.rs_2])]=reg[inst.rs_1];
    }
    else if(inst.inst_name=="load" && inst.rd != 0) {
        reg[inst.rd]= mem[(inst.offeset+reg[inst.rs_1])];
    }
    else if(inst.inst_name=="call") {
        reg[1]= inst.pc+1;
        pc = inst.offeset;
        inst.b_flag = true;
    }
    else if(inst.inst_name=="ret") {
        pc=reg[1];
        inst.b_flag = true;
    }
}




void PrintTableHeader() {
    cout << setw(15) << "Instruction" << setw(15) << "Issue" << setw(15) << "Exec Start" << setw(15) << "Exec End" << setw(15) << "Write Back" << "\n";
}

void PrintTableRow(const Inst& instruction) {
    cout << setw(15) << instruction.inst_name << setw(15) << instruction.issue << setw(15) << instruction.exec_start
         << setw(15) << instruction.exec_end << setw(15) << instruction.wb << "\n";
}


int main(){

    string inst_path = "E:/Courses material/Computer Architecture/Project2/Inst1.txt"; //initially
    string data_path = "E:/Courses material/Computer Architecture/Project2/Data1.txt"; //initially
    string hardware_path = "E:/Courses material/Computer Architecture/Project2/hardware.txt"; //initially

    cout<<"Hello, Welcome to femTomas Tomasulo Algorithm Simulation!\nPlease enter the instructions file name:\n";
    cin>>inst_path;

    cout<<"Please enter the data file name. If there is no need for it, enter N/A:\n";
    cin>>data_path;

    cout << "Please select if you want a custom hardware for your program(y, n) ";
    char hardware;
    cin >> hardware;
    while (tolower(hardware) != 'y' && tolower(hardware) != 'n') {
        cout << "Sorry, this is not a valid selection, please try again\n"
            << "Choose y or n\n";
        cin >> hardware;
    }
    

    if(tolower(hardware) == 'n'){
        stations["load"]={2,3};
        stations["store"]={2,3};
        stations["bne"]={1,1};
        stations["call"]={1,1};
        stations["add"]={3,2};
        stations["nand"]={1,1};
        stations["div"]={1,10};
    }
    else{
        cout<<"Please enter the hardware file name for reservation stations and cycles:\n";
        cin>>hardware_path;
        FillFromFile_hardware(hardware_path);
    } 

    vector<int> issued, started, excuted, predicted;
    vector<int> erase_start;
	vector<Inst> instructions = FillFromFile(inst_path);
    if(data_path != "N/A")
        FillFromFile_data(data_path);

    cout << "Please select your starting address for the instructions(initial pc): ";
    cin>>pc;
    int initial_pc = pc;
    int clock = 1;
    for(;;clock++){
        
        //WB stage
        for(int ex = 0; ex < excuted.size(); ++ex){
            //cout<<"DEBUG:: WB\n";     
            instructions[excuted[ex]].wb = clock;  //update wb time
            operation_excution(instructions[excuted[ex]]);
            stations[instructions[excuted[ex]].inst_station].first++;  //reservation station is free

            //handling branch predictions
            if(instructions[excuted[ex]].inst_name == "bne" || instructions[excuted[ex]].inst_name == "call" || instructions[excuted[ex]].inst_name == "ret"){ 
                if(instructions[excuted[ex]].b_flag == false)  //correct prediction
                    predicted.erase(predicted.begin());
                else{  //misprediction
                    if(instructions[excuted[ex]].inst_name == "bne") mispredictions++;
                    predicted.clear();
                    int bremov = issued.size()-1;
                    for(; bremov >= 0; --bremov){
                        if(issued[bremov]<excuted[ex]) break;
                        else{
                            stations[instructions[issued[bremov]].inst_station].first++;
                        }    
                    }
                    
                    issued.erase(issued.begin() + bremov + 1, issued.end());     
                }
            }

            excuted.erase(excuted.begin() + ex);
            --ex;     
        }

        for(int ind = erase_start.size()-1; ind >= 0; --ind){
            started.erase(started.begin() + erase_start[ind]);
        }
        erase_start.clear();
        

        //Excuted stage
        for(int st = 0; st < started.size(); ++st){
            //cout<<"DEBUG:: Excuted\n";     
            if(clock - instructions[started[st]].exec_start >= stations[instructions[started[st]].inst_station].second - 1){
                instructions[started[st]].exec_end = clock;  //update finishing excution time
                excuted.push_back(started[st]);
                erase_start.push_back(st);
            }
        }


        //Started Excution stage
        bool hazard = false;
        for(int iss = 0; iss < issued.size(); ++iss){
            if(predicted.empty() || issued[iss] <= predicted[0]){  //stopping excution in case of branch predictions 
                //cout<<"DEBUG:: Started\n";     
                hazard = false;
                for(int st = 0; st < started.size(); ++st){  //detecting RAW hazard
                    if( instructions[started[st]].rd != 0 && //No hazards when rd = 0
                    ((instructions[issued[iss]].rs_1 == instructions[started[st]].rd) || (instructions[issued[iss]].rs_2 == instructions[started[st]].rd)))
                        {hazard = true; break;}
                }
                if(!hazard){
                    instructions[issued[iss]].exec_start = clock;  //update starting excution time
                    started.push_back(issued[iss]);

                    //in case only 1 span cycle, do the excuted logic
                    if(stations[instructions[issued[iss]].inst_station].second == 1){
                        instructions[started[started.size()-1]].exec_end = clock;  //update finishing excution time
                        excuted.push_back(started[started.size()-1]);
                        erase_start.push_back(started.size()-1);
                    }

                    issued.erase(issued.begin() + iss);
                    --iss;
                }
                
            }
        }


        //Issue stage
        if(pc<instructions.size()){
            if(stations[instructions[pc].inst_station].first > 0){
                //cout<<"DEBUG:: Issued\n";
                instructions[pc].issue = clock;  //update issue time
                //cout<<instructions[pc].inst_name;
                stations[instructions[pc].inst_station].first--;
                issued.push_back(pc);

                //handling branch 
                if(instructions[pc].inst_name == "bne" || instructions[pc].inst_name == "call" || instructions[pc].inst_name == "ret"){
                    predicted.push_back(pc);
                    instructions[pc].pc = pc;
                    branches++;
                }
                pc++;
            }
        }

        // cout<<"\n";
        // for(int freddy = 0; freddy < 8; ++freddy){
        //     cout<<reg[freddy]<<"  ";
        // }
        // cout<<"\n";    

        if(issued.empty() && started.empty() && excuted.empty())
            break;
        
        // cout<<"Please enter anything to continue to the next cycle: "<<clock;
        // string trash;
        // cin>>trash;

    }

    // for(int i=initial_pc; i< instructions.size(); ++i){
    //     cout<<instructions[i].inst_name<<": "<<instructions[i].issue<<"  "<<instructions[i].exec_start<<"  "<<instructions[i].exec_end<<"  "<<instructions[i].wb<<"\n";
    // }
    
    PrintTableHeader();

    for (int i = initial_pc; i < instructions.size(); ++i) {
        PrintTableRow(instructions[i]);
    }
    cout<<"Total Excution Time = "<<clock<<"\n";
    if(branches == 0) cout<<"There were no branches to know the midprediction percentage\n";
    else cout<<"Branch Misprediction Percentage = "<<((float) mispredictions/(float)branches) * 100 << "%\n";
    cout<<"IPC = "<<pc<<"\n";
    //Table
    return 0;
}
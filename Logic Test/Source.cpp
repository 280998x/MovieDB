#include <iostream>
#include <vector>
#include <string>

using namespace std;

vector<vector<int>> grid;

bool containsZero(vector<vector<int>> grid) {

	for (int i = 0; i < grid.size(); i++) {

		if (count(grid[i].begin(), grid[i].end(), 0)) return true;

	}

	return false;

}

void print() {

	for (int i = 0; i < grid.size(); i++) {

		for (int j = 0; j < grid[i].size(); j++) {

			cout << grid[i][j] << " ";

		}

		cout << endl;

	}

	cout << endl;

}

string moveUp(int x, int y) {

	for (x; x >= 0; x--) {

		if (grid[x][y] == 1) { break; }

		grid[x][y] = 1;

	}

	return "U";

}

string moveLeft(int x, int y) {

	for (y; y >= 0; y--) {

		if (grid[x][y] == 1) { break; }

		grid[x][y] = 1;

	}

	x--;
	y++;

	if (!containsZero(grid))
		return "L";

	return moveUp(x, y);

}

string moveDown(int x, int y) {

	for (x; x < grid.size(); x++) {

		if (grid[x][y] == 1) { break; }

		grid[x][y] = 1;

	}

	x--;
	y--;

	if (!containsZero(grid))
		return "D";
	
	return moveLeft(x, y);

}

string moveRight(int x) {

	int y;

	for (y = x; y < grid[x].size(); y++) {

		if (grid[x][y] == 1) { break; }

		grid[x][y] = 1;

	}

	x++;
	y--;

	if (!containsZero(grid))
		return "R";
	
	return moveDown(x, y);

}

int main() {

	vector<string> directions;

	int times;

	cin >> times;

	if (times < 1) { return 0; }

	for (int i = 0; i < times; i++) {

		int cols, rows;

		cin >> rows;
		cin >> cols;

		grid.resize(rows);

		for (int i = 0; i < rows; i++)
			grid[i].resize(cols);

		int step = 0;
		string dir;

		while (containsZero(grid)) {

			dir = moveRight(step);

			step++;

		}

		directions.push_back(dir);
		grid.clear();

	}

	for (int i = 0; i < directions.size(); i++) {

		cout << directions[i] << endl;

	}

	system("pause");

	return 0;

}
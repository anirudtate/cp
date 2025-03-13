#include <bits/stdc++.h>
using namespace std;

#ifdef LOCAL
#include "algo/debug.h"
#else
#define dbg(...) 42
#endif

#define sz(x) (int)x.size()
#define all(x) a.begin(), a.end()
/*using ll = long long;*/
#define nl '\n'
#define int long long

void solve() {
  int n;
  cin >> n;
  map<int, int> m;
  priority_queue<int> pq;

  for (int i = 0; i < n; i++) {
    int x;
    cin >> x;
    pq.push(x);
  }
  while (sz(pq) > 1) {
    int first = pq.top();
    pq.pop();
    int second = pq.top();
    pq.pop();
    int third = first + second - 1;
    pq.push(third);
  }
  cout << pq.top() << nl;
}

signed main() {
  int tt = 1;
  cin >> tt;
  while (tt--) {
    solve();
  }
  return 0;
}

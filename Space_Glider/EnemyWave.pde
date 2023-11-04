class EnemyWave{
  private Queue<EnemySpawn> spawnQueue;
  
  public EnemyWave(){
    spawnQueue = new PriorityQueue<EnemySpawn>(10, new EnemySpawnComparator());
  }
  
  public void addEnemySpawn(EnemySpawn s){
    spawnQueue.offer(s);
  }
  
  public void spawnEnemies(int time, Set<Enemy> enemies){
    while (!spawnQueue.isEmpty() && spawnQueue.peek().spawnTime <= time){
      enemies.add(spawnQueue.poll().enemy);
    }
  }
  
  public boolean isEmpty(){
    return spawnQueue.isEmpty();
  }
}

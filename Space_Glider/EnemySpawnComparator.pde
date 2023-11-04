class EnemySpawnComparator implements Comparator<EnemySpawn>{
  public int compare(EnemySpawn s1, EnemySpawn s2){
    return s1.spawnTime - s2.spawnTime;
  }
}

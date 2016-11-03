WP = myPerfect * pinv(dataset);
WP2 = myPerfect * pinv(dataset2);
WP3 = T * pinv(bigDataSet);

intRes11 = WP * dataset;
intRes12 = WP * testSet.P;

intRes21 = WP2 * dataset2;
intRes22 = WP2 * testSet2.P;

intRes31 = WP3 * bigDataSet;
intRes32 = WP3 * testSet2.P;
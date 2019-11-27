package com.example.myapplication;

import android.os.Environment;

import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.functions.LinearRegression;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.converters.ArffLoader;

public class Test {
    private static String folderDataset = "/dataset";
    private static Classifier classifier;

    private static Instances getDataSet(String filename) {
        Instances dataSet = null;
        ArffLoader loader = new ArffLoader();
        try {
            File f = new File(Environment.getExternalStorageDirectory().getAbsolutePath() + folderDataset , filename);
            loader.setFile(f);
            dataSet = loader.getDataSet();
            dataSet.setClassIndex(1);

        } catch (IOException ex) {
            Logger.getLogger(Test.class.getName()).log(Level.SEVERE, null, ex);
        }
        return dataSet;
    }

    public static void trainAndTest() {
        try {
            Instances trainingDataSet = getDataSet("kc_house_data_train.arff");
            Instances testDataSet = getDataSet("kc_house_data_test.arff");
            // choose type of supervised learning to be Linear Regression
            classifier = new LinearRegression();
            classifier.buildClassifier(trainingDataSet);
            //Testing for adjust the factors
            Evaluation eval = new Evaluation(trainingDataSet);
            eval.evaluateModel(classifier, testDataSet);

            System.out.println("Linear Regression");
            System.out.println(eval.toSummaryString());
            System.out.println(" Expression for input data");
            System.out.println(classifier);
        } catch (Exception ex) {
            Logger.getLogger(Test.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static double predictOneInstance(String date1, Integer bedrooms,
                                            double bathrooms, double sqft_loft,
                                            Integer floors, Integer waterfront, Integer view,
                                            Integer condition, Integer grade, double sqft_above,
                                            double sqft_basement, String yr_built, String renovated) {
        double value = 0;
        try {
            Instance predictDataset = getDataSet("kc_house_data_predict.arff").firstInstance();
            predictDataset.attribute(0).parseDate(date1);
            predictDataset.setValue(2, bedrooms);
            predictDataset.setValue(3, bathrooms);
            predictDataset.setValue(4, sqft_above + sqft_basement);
            predictDataset.setValue(5, sqft_loft);
            predictDataset.setValue(6, floors);
            predictDataset.setValue(7, waterfront);
            predictDataset.setValue(8, view);
            predictDataset.setValue(9, condition);
            predictDataset.setValue(10, grade);
            predictDataset.setValue(11, sqft_above);
            predictDataset.setValue(12, sqft_basement);
            predictDataset.attribute(13).parseDate(yr_built);
            predictDataset.setValue(14, renovated);
            value = classifier.classifyInstance(predictDataset);
            System.out.println(value);
        } catch (Exception ex) {
            Logger.getLogger(Test.class.getName()).log(Level.SEVERE, null, ex);
        }
        return value;
    }
}

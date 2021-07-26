#include "opencv2/opencv.hpp"
#include "opencv2/face/facerec.hpp"
#include "opencv2/face/facemark.hpp"
#include "opencv2/face/facemark_train.hpp"
#include "opencv2/face/facemarkLBF.hpp"
#include "opencv2/face/facemarkAAM.hpp"
#include "opencv2/face/face_alignment.hpp"
#include "opencv2/face/mace.hpp"
#include <bits/stdc++.h>

using namespace std;
// using namespace rapidjson;
int main(){
    int key;
    double confidence;
    cv::Mat frame, image, face;
    cv::String line, name, attendance_model, label;
    string facelabel;
    vector<int> numDetect;
    vector<cv::String> names;
    vector<int> nums;
    map<string, cv::Scalar> colors;

    cv::VideoCapture capture(0);
    attendance_model = "Face-Recognition-Model.xml";
    cv::namedWindow("Video Player");
    int name_color;
    cv::Scalar color;       
    cv::Ptr<cv::face::LBPHFaceRecognizer> model = cv::face::LBPHFaceRecognizer::create();
    cv::String image_dir = "D:/Computing/C++_Projects/Attendance/images/";
    cv::String filename = "faces.csv";
    //alternatively use filesystem but I couldn't get it installed properly
    ifstream file(filename.c_str(), ifstream::in);
    srand(time(0));
    while (getline(file, line)) {
        stringstream line_stream(line);
        getline(line_stream, name, ',');
        getline(line_stream, facelabel);
        colors[name] = cv::Scalar(rand()%255, rand()%255, rand()%255);
        names.push_back(name);
        nums.push_back(stoi(facelabel));
    }
    
    for (int i=0;i<names.size();i++){
        cout<<nums[i]<<" "<<names[i]<<" "<<colors[names[i]]<<endl;
        model->setLabelInfo(nums[i], names[i]);
    }



    model->read(attendance_model);
    int predictedLabel=-1;
    cv::CascadeClassifier cascade;
    vector<cv::Rect> faces;
    cv::Mat gray, smallImg;
    double fx=1.0;
    // Load classifiers from "data/lbpcascades" directory 
    cascade.load("data/lbpcascades/lbpcascade_frontalface_improved.xml"); 
    // cascade.load("data/haarcascades/haarcascade_frontalface_alt.xml" ); 
    while(true){   
        gray.release();
        smallImg.release();
        capture >> image;
        cv::flip(image, frame, 1);

        faces.clear();
        cvtColor(frame, gray, cv::COLOR_BGR2GRAY );
        cv::resize(gray, smallImg, cv::Size(), fx, fx, cv::INTER_LINEAR); 
        cv::equalizeHist(smallImg, smallImg);

        cascade.detectMultiScale(smallImg, faces, numDetect, 1.1, 3, 0, cv::Size(30, 30));
        
        for (size_t i = 0; i < faces.size(); i++){
            cv::Rect r = faces[i];
            cv::Rect r1;
            r.width = (int)(r.width * 1.25);
            r.height = (int)(r.height * 1.25);
            r.x = (int)(r.x-0.05*r.x);
            r.y = (int)(r.y-0.05*r.y);
            r1.x = r.x;
            r1.y = (int)(r.y+(r.height));
            r1.width = r.width;
            r1.height = 20;
            face = cv::Mat(gray, r);

            try{
                model->predict(face, predictedLabel, confidence);
                name = model->getLabelInfo(predictedLabel);
            }
            catch(const cv::Exception& ex){
                vector<cv::Mat> input {face};
                cout<<"Who is this?"<<endl;
                getline(cin, name);
                names.push_back(name);
                nums.push_back(static_cast<int>(names.size()));
                model->train(input, vector<int> {static_cast<int>(names.size())});
                predictedLabel = static_cast<int>(names.size());
                model->setLabelInfo(predictedLabel, name);
                confidence = 1.0;
                if (colors.find(name) == colors.end()){
                    colors[name] = cv::Scalar(rand()%255, rand()%255, rand()%255);
                }
            }

            cout<<"Name: "<<name<<" | Confidence: "<<confidence<<endl;
            vector<cv::Mat> input {face};
            if (confidence > 90){
                cout<<"Who is this?"<<endl;
                getline(cin, name);
                // save image, update csv, update model
                names.push_back(name);
                nums.push_back(static_cast<int>(names.size()));
                predictedLabel = static_cast<int>(names.size());
                model->setLabelInfo(predictedLabel, name);
                if (colors.find(name) == colors.end()){
                    colors[name] = cv::Scalar(rand()%255, rand()%255, rand()%255);
                }
            }
            model->update(input, vector<int> {predictedLabel});
            cv::rectangle(frame, r, colors[(string)(name)], 3);
            cv::rectangle(frame, r1, colors[(string)(name)], -1, cv::LINE_8);
            cv::putText(frame, name, cv::Point(r1.x, r1.y+15), cv::FONT_HERSHEY_PLAIN, 1.5, cv::Scalar(255, 255, 255), 2, cv::LINE_AA);
        }
        cv::imshow("Video Player", frame);
        key = cv::waitKey(1);
        if (key == (int)('q')){
            break;
        }
    }
    model->write(attendance_model);
    ofstream out(filename.c_str());
    
    for (int i=0; i<nums.size(); i++){
        label = model->getLabelInfo(nums[i]);
        out<<label<<","<<nums[i]<<"\n";
        cout<<label<<", "<<nums[i]<<"\n";
    }
    out.close();
    cv::destroyAllWindows();
    capture.release();
    return 0;
}

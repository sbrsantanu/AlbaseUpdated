//
//  OCRDataObjectModel.h
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCRUserDataObjectModel : NSObject

@property (nonatomic,retain) NSString *UserId;
@property (nonatomic,retain) NSString *Firstname;
@property (nonatomic,retain) NSString *Lastname;
@property (nonatomic,retain) NSString *DateOfBirth;
@property (nonatomic,retain) NSString *UserPhoneNumber;
@property (nonatomic,retain) NSString *Usersemail;
@property (nonatomic,retain) NSString *Gender;
@property (nonatomic,retain) NSString *Fullname;
@property (nonatomic,retain) NSString *ProfileImage;

-(id)initWithFirstname:(NSString *)ParamFirstname
              Lastname:(NSString *)ParamLastname
           DateOfBirth:(NSString *)ParamDateOfBirth
       UserPhoneNumber:(NSString *)ParamUserPhoneNumber
             Usersemail:(NSString *)ParamUseremail
                Gender:(NSString *)ParamGender
          ProfileImage:(NSString *)ParamProfileImage
                UserId:(NSString *)ParamUserId;

@end


@interface OCRNoteDataObjectModel : NSObject

@property (nonatomic,retain) NSString *NoteId;
@property (nonatomic,retain) NSString *NoteAddedDate;
@property (nonatomic,retain) NSString *NoteDetails;

-(id)initWithNoteId:(NSString *)ParamNoteId
      NoteAddedDate:(NSString *)ParamNoteAddedDate
        NoteDetails:(NSString *)ParamNoteDetails;
@end

@interface OCRAppointmentDataObjectModel : NSObject

@property (nonatomic,retain) NSString *AppointmentID;
@property (nonatomic,retain) NSString *Appointmentaddedon;
@property (nonatomic,retain) NSString *Note;
@property (nonatomic,retain) NSString *ApponitmentStartDate;
@property (nonatomic,retain) NSString *ApponitmentEndDate;
@property (nonatomic,retain) NSString *ApponitmentDuration;
@property (nonatomic,retain) NSString *Apponitmentstatus;
@property (nonatomic,retain) NSString *AppointmentTitle;
@property (nonatomic,retain) NSString *AppointmentWith;
@property (nonatomic,retain) NSString *AppointmentWithname;
@property (nonatomic,retain) NSString *AppointmentStartTime;
@property (nonatomic,retain) NSString *AppointmentEndtime;

-(id)initWithAppointmentID:     (NSString *)ParamAppointmentID
        Appointmentaddedon:     (NSString *)ParamAppointmentaddedon
                      Note:     (NSString *)ParamNote
        ApponitmentStartDate:   (NSString *)ParamApponitmentStartDate
        ApponitmentEndDate:     (NSString *)ParamApponitmentEndDate
        ApponitmentDuration:    (NSString *)ParamApponitmentDuration
        Apponitmentstatus:      (NSString *)ParamApponitmentstatus
        AppointmentTitle:       (NSString *)ParamAppointmentTitle
        AppointmentWith:        (NSString *)ParamAppointmentWith
        AppointmentWithname:    (NSString *)ParamAppointmentWithname
        AppointmentStartTime:   (NSString *)ParamAppointmentStartTime
        AppointmentEndtime:     (NSString *)ParamAppointmentEndtime;

@end

@interface OCRScanDataObjectModel : NSObject

@property (nonatomic,retain) NSString *PolicyNumber;
@property (nonatomic,retain) NSString *Status;
@property (nonatomic,retain) NSString *PolicyDate;
@property (nonatomic,retain) NSString *PaidToDate;
@property (nonatomic,retain) NSString *ModalPremium;
@property (nonatomic,retain) NSString *NextModalPremium;
@property (nonatomic,retain) NSString *PayUpDate;
@property (nonatomic,retain) NSString *MaturityDate;
@property (nonatomic,retain) NSString *InsuredAddress;
@property (nonatomic,retain) NSString *AdjustedPremium;
@property (nonatomic,retain) NSString *Gender;
@property (nonatomic,retain) NSString *Name;
@property (nonatomic,retain) NSString *NRIC;
@property (nonatomic,retain) NSString *DOB;
@property (nonatomic,retain) NSString *IssueAge;
@property (nonatomic,retain) NSString *Owner;
@property (nonatomic,retain) NSString *PaymentMode;
@property (nonatomic,retain) NSString *PaymentMothod;
@property (nonatomic,retain) NSString *BillToDate;

-(id)initWithStatus:     (NSString *)ParamStatus
         PolicyDate:     (NSString *)ParamPolicyDate
         PaidToDate:     (NSString *)ParamPaidToDate
       ModalPremium:     (NSString *)ParamModalPremium
   NextModalPremium:     (NSString *)NextModalPremium
          PayUpDate:     (NSString *)ParamPayUpDate
       MaturityDate:     (NSString *)ParamMaturityDate
     InsuredAddress:     (NSString *)ParamInsuredAddress
    AdjustedPremium:     (NSString *)ParamAdjustedPremium
             Gender:     (NSString *)ParamGender
               Name:     (NSString *)ParamName
               NRIC:     (NSString *)ParamNRIC
                DOB:     (NSString *)ParamDOB
           IssueAge:     (NSString *)ParamIssueAge
              Owner:     (NSString *)ParamOwner
        PaymentMode:     (NSString *)ParamPaymentMode
      PaymentMothod:     (NSString *)ParamPaymentMothod
         BillToDate:     (NSString *)ParamBillToDate
       PolicyNumber:     (NSString *)ParamPolicyNumber;
@end

@interface OcrInsurenceDataObjectModel : NSObject

@property (nonatomic, retain) NSString * InsurencePolicyNumber;
@property (nonatomic, retain) NSString * InsurenceaddedDate;
@property (nonatomic, retain) NSString * InsurenceadjustedPremium;
@property (nonatomic, retain) NSString * InsurencebillToDate;
@property (nonatomic, retain) NSString * InsurenceinsuredAddress;
@property (nonatomic, retain) NSString * InsurenceinsurenceID;
@property (nonatomic, retain) NSString * InsurenceissueAge;
@property (nonatomic, retain) NSString * InsurencematurityDate;
@property (nonatomic, retain) NSString * InsurencemodalPremium;
@property (nonatomic, retain) NSString * InsurencenextModalPremium;
@property (nonatomic, retain) NSString * Insurencenric;
@property (nonatomic, retain) NSString * Insurenceowner;
@property (nonatomic, retain) NSString * InsurencepaidToDate;
@property (nonatomic, retain) NSString * InsurencepaymentMode;
@property (nonatomic, retain) NSString * InsurencepaymentMothod;
@property (nonatomic, retain) NSString * InsurencepayUpDate;
@property (nonatomic, retain) NSString * InsurencepolicyDate;
@property (nonatomic, retain) NSString * Insurencestatus;
@property (nonatomic, retain) NSString * InsurenceuserId;

-(id)initWithInsurenceaddedDate:    (NSString *)ParamInsurenceaddedDate
       InsurenceadjustedPremium:    (NSString *)ParamInsurenceadjustedPremium
            InsurencebillToDate:    (NSString *)ParamInsurencebillToDate
        InsurenceinsuredAddress:    (NSString *)ParamInsurenceinsuredAddress
           InsurenceinsurenceID:    (NSString *)ParamInsurenceinsurenceID
              InsurenceissueAge:    (NSString *)ParamInsurenceissueAge
          InsurencematurityDate:    (NSString *)ParamInsurencematurityDate
          InsurencemodalPremium:    (NSString *)ParamInsurencemodalPremium
      InsurencenextModalPremium:    (NSString *)ParamInsurencenextModalPremium
                  Insurencenric:    (NSString *)ParamInsurencenric
                 Insurenceowner:    (NSString *)ParamInsurenceowner
            InsurencepaidToDate:    (NSString *)ParamInsurencepaidToDate
           InsurencepaymentMode:    (NSString *)ParamInsurencepaymentMode
         InsurencepaymentMothod:    (NSString *)ParamInsurencepaymentMothod
             InsurencepayUpDate:    (NSString *)ParamInsurencepayUpDate
            InsurencepolicyDate:    (NSString *)ParamInsurencepolicyDate
                Insurencestatus:    (NSString *)ParamInsurencestatus
                InsurenceuserId:    (NSString *)ParamInsurenceuserId
          InsurencePolicyNumber:    (NSString *)ParamInsurencePolicyNumber;

@end

@interface OCRAccidentPolicydetails : NSObject

@property (nonatomic,retain) NSString * AccidentPolicyStatus;
@property (nonatomic,retain) NSString * AccidentGender;
@property (nonatomic,retain) NSString * AccidentName;
@property (nonatomic,retain) NSString * AccidentNRIC;
@property (nonatomic,retain) NSString * AccidentDOB;
@property (nonatomic,retain) NSString * AccidentIssueAge;
@property (nonatomic,retain) NSString * AccidentPaymentMode;
@property (nonatomic,retain) NSString * AccidentPaymentMothod;
@property (nonatomic,retain) NSString * AccidentEffictiveDate;
@property (nonatomic,retain) NSString * AccidentModelPremium;
@property (nonatomic,retain) NSString * AccidentExpiryDate;
@property (nonatomic,retain) NSString * AccidentReinStateDate;
@property (nonatomic,retain) NSString * AccidentAddress;
@property (nonatomic,retain) NSString * AccidentOcupationClass;
@property (nonatomic,retain) NSString * AccidentPaidtoDate;
@property (nonatomic,retain) NSString * AccidentLapseDate;
@property (nonatomic,retain) NSString * AccidentRenewalBonus;
@property (nonatomic,retain) NSString * AccidentPolicyNumber;

-(id)initWithAccidentPolicyStatus:  (NSString *)ParamAccidentPolicyStatus
                   AccidentGender:  (NSString *)ParamAccidentGender
                     AccidentName:  (NSString *)ParamAccidentName
                     AccidentNRIC:  (NSString *)ParamAccidentNRIC
                      AccidentDOB:  (NSString *)ParamAccidentDOB
                 AccidentIssueAge:  (NSString *)ParamAccidentIssueAge
              AccidentPaymentMode:  (NSString *)ParamAccidentPaymentMode
            AccidentPaymentMothod:  (NSString *)ParamAccidentPaymentMothod
            AccidentEffictiveDate:  (NSString *)ParamAccidentEffictiveDate
             AccidentModelPremium:  (NSString *)ParamAccidentModelPremium
               AccidentExpiryDate:  (NSString *)ParamAccidentExpiryDate
            AccidentReinStateDate:  (NSString *)ParamAccidentReinStateDate
                  AccidentAddress:  (NSString *)ParamAccidentAddress
           AccidentOcupationClass:  (NSString *)ParamAccidentOcupationClass
               AccidentPaidtoDate:  (NSString *)ParamAccidentPaidtoDate
                AccidentLapseDate:  (NSString *)ParamAccidentLapseDate
             AccidentRenewalBonus:  (NSString *)ParamAccidentRenewalBonus
             AccidentPolicyNumber:  (NSString *)paramAccidentPolicyNumber;

@end

@interface EditableUserData : NSObject

@property (nonatomic,retain) NSString * UserFirstName;
@property (nonatomic,retain) NSString * UserlastName;
@property (nonatomic,retain) NSString * UsersEmail;
@property (nonatomic,retain) NSString * UserPhoneNumber;
@property (nonatomic,retain) NSString * UserDateOfBirth;
@property (nonatomic,retain) NSString * UserGender;
@property (nonatomic,retain) NSString * UserPolicyNumber;

-(id)initWithUserFirstName:     (NSString *)ParamUserFirstName
              UserlastName:     (NSString *)ParamUserlastName
                 UsersEmail:     (NSString *)ParamUserEmail
           UserPhoneNumber:     (NSString *)ParamUserPhoneNumber
           UserDateOfBirth:     (NSString *)ParamUserDateOfBirth
                UserGender:     (NSString *)ParamUserGender
          UserPolicyNumber:     (NSString *)ParamUserPolicyNumber;

@end

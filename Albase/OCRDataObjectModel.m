//
//  OCRDataObjectModel.m
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRDataObjectModel.h"

@implementation OCRUserDataObjectModel

-(id)initWithFirstname:     (NSString *)ParamFirstname
              Lastname:     (NSString *)ParamLastname
           DateOfBirth:     (NSString *)ParamDateOfBirth
       UserPhoneNumber:     (NSString *)ParamUserPhoneNumber
             Usersemail:     (NSString *)ParamUseremail
                Gender:     (NSString *)ParamGender
          ProfileImage:     (NSString *)ParamProfileImage
                UserId:     (NSString *)ParamUserId
{
    self = [super init];
    if (self) {
        self.Firstname          = ParamFirstname;
        self.Lastname           = ParamLastname;
        self.DateOfBirth        = ParamDateOfBirth;
        self.UserPhoneNumber    = ParamUserPhoneNumber;
        self.Usersemail          = ParamUseremail;
        self.Gender             = ParamGender;
        self.Fullname           = [NSString stringWithFormat:@"%@ %@",ParamFirstname,ParamLastname];
        self.ProfileImage       = ParamProfileImage;
        self.UserId             = ParamUserId;
    }
    return self;
}
@end


@implementation OCRNoteDataObjectModel

-(id)initWithNoteId:     (NSString *)ParamNoteId
      NoteAddedDate:     (NSString *)ParamNoteAddedDate
        NoteDetails:     (NSString *)ParamNoteDetails
{
    self = [super init];
    if (self) {
        self.NoteId         = ParamNoteId;
        self.NoteAddedDate  = ParamNoteAddedDate;
        self.NoteDetails    = ParamNoteDetails;
    }
    return self;
}

@end

@implementation OCRAppointmentDataObjectModel

-(id)initWithAppointmentID:     (NSString *)ParamAppointmentID
        Appointmentaddedon:     (NSString *)ParamAppointmentaddedon
                      Note:     (NSString *)ParamNote
      ApponitmentStartDate:     (NSString *)ParamApponitmentStartDate
        ApponitmentEndDate:     (NSString *)ParamApponitmentEndDate
       ApponitmentDuration:     (NSString *)ParamApponitmentDuration
         Apponitmentstatus:     (NSString *)ParamApponitmentstatus
          AppointmentTitle:     (NSString *)ParamAppointmentTitle
           AppointmentWith:     (NSString *)ParamAppointmentWith
       AppointmentWithname:     (NSString *)ParamAppointmentWithname
      AppointmentStartTime:     (NSString *)ParamAppointmentStartTime
        AppointmentEndtime:     (NSString *)ParamAppointmentEndtime
{
    self = [super init];
    if(self)
    {
        self.AppointmentID          = ParamAppointmentID;
        self.Appointmentaddedon     = ParamAppointmentaddedon;
        self.Note                   = ParamNote;
        self.ApponitmentStartDate   = ParamApponitmentStartDate;
        self.ApponitmentEndDate     = ParamApponitmentEndDate;
        self.ApponitmentDuration    = ParamApponitmentDuration;
        self.Apponitmentstatus      = ParamApponitmentstatus;
        self.AppointmentTitle       = ParamAppointmentTitle;
        self.AppointmentWith        = ParamAppointmentWith;
        self.AppointmentWithname    = ParamAppointmentWithname;
        self.AppointmentStartTime   = ParamAppointmentStartTime;
        self.AppointmentEndtime     = ParamAppointmentEndtime;
    }
    return self;
}


@end

@implementation OCRScanDataObjectModel

-(id)initWithStatus:    (NSString *)ParamStatus
         PolicyDate:    (NSString *)ParamPolicyDate
         PaidToDate:    (NSString *)ParamPaidToDate
       ModalPremium:    (NSString *)ParamModalPremium
   NextModalPremium:    (NSString *)NextModalPremium
          PayUpDate:    (NSString *)ParamPayUpDate
       MaturityDate:    (NSString *)ParamMaturityDate
     InsuredAddress:    (NSString *)ParamInsuredAddress
    AdjustedPremium:    (NSString *)ParamAdjustedPremium
             Gender:    (NSString *)ParamGender
               Name:    (NSString *)ParamName
               NRIC:    (NSString *)ParamNRIC
                DOB:    (NSString *)ParamDOB
           IssueAge:    (NSString *)ParamIssueAge
              Owner:    (NSString *)ParamOwner
        PaymentMode:    (NSString *)ParamPaymentMode
      PaymentMothod:    (NSString *)ParamPaymentMothod
         BillToDate:    (NSString *)ParamBillToDate
       PolicyNumber:    (NSString *)ParamPolicyNumber
{
    self = [super init];
    if(self)
    {
        self.Status             = ParamStatus;
        self.PolicyDate         = ParamPolicyDate;
        self.PaidToDate         = ParamPaidToDate;
        self.ModalPremium       = ParamModalPremium;
        self.NextModalPremium   = NextModalPremium;
        self.PayUpDate          = ParamPayUpDate;
        self.MaturityDate       = ParamMaturityDate;
        self.InsuredAddress     = ParamInsuredAddress;
        self.AdjustedPremium    = ParamAdjustedPremium;
        self.Gender             = ParamGender;
        self.Name               = ParamName;
        self.NRIC               = ParamNRIC;
        self.DOB                = ParamDOB;
        self.IssueAge           = ParamIssueAge;
        self.Owner              = ParamOwner;
        self.PaymentMode        = ParamPaymentMode;
        self.PaymentMothod      = ParamPaymentMothod;
        self.BillToDate         = ParamBillToDate;
        self.PolicyNumber       = ParamPolicyNumber;
    }
    return self;
}

@end

@implementation OcrInsurenceDataObjectModel

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
          InsurencePolicyNumber:    (NSString *)ParamInsurencePolicyNumber
{
    self = [super init];
    if (self) {
        self.InsurenceaddedDate             = ParamInsurenceaddedDate;
        self.InsurenceadjustedPremium       = ParamInsurenceadjustedPremium;
        self.InsurencebillToDate            = ParamInsurencebillToDate;
        self.InsurenceinsuredAddress        = ParamInsurenceinsuredAddress;
        self.InsurenceinsurenceID           = ParamInsurenceinsurenceID;
        self.InsurenceissueAge              = ParamInsurenceissueAge;
        self.InsurencematurityDate          = ParamInsurencematurityDate;
        self.InsurencemodalPremium          = ParamInsurencemodalPremium;
        self.Insurencenric                  = ParamInsurencenric;
        self.Insurenceowner                 = ParamInsurenceowner;
        self.InsurencepaidToDate            = ParamInsurencepaidToDate;
        self.InsurencepaymentMode           = ParamInsurencepaymentMode;
        self.InsurencepayUpDate             = ParamInsurencepayUpDate;
        self.InsurencepolicyDate            = ParamInsurencepolicyDate;
        self.Insurencestatus                = ParamInsurencestatus;
        self.InsurenceuserId                = ParamInsurenceuserId;
        self.InsurencePolicyNumber          = ParamInsurencePolicyNumber;
        
    }
    return self;
}

@end

@implementation OCRAccidentPolicydetails

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
             AccidentPolicyNumber:  (NSString *)paramAccidentPolicyNumber
{
    self = [super init];
    if (self) {
        self.AccidentPolicyStatus   = ParamAccidentPolicyStatus;
        self.AccidentGender         = ParamAccidentGender;
        self.AccidentName           = ParamAccidentName;
        self.AccidentNRIC           = ParamAccidentNRIC;
        self.AccidentDOB            = ParamAccidentDOB;
        self.AccidentIssueAge       = ParamAccidentIssueAge;
        self.AccidentPaymentMode    = ParamAccidentPaymentMode;
        self.AccidentPaymentMothod  = ParamAccidentPaymentMothod;
        self.AccidentEffictiveDate  = ParamAccidentEffictiveDate;
        self.AccidentModelPremium   = ParamAccidentModelPremium;
        self.AccidentExpiryDate     = ParamAccidentExpiryDate;
        self.AccidentReinStateDate  = ParamAccidentReinStateDate;
        self.AccidentAddress        = ParamAccidentAddress;
        self.AccidentOcupationClass = ParamAccidentOcupationClass;
        self.AccidentPaidtoDate     = ParamAccidentPaidtoDate;
        self.AccidentLapseDate      = ParamAccidentLapseDate;
        self.AccidentRenewalBonus   = ParamAccidentRenewalBonus;
        self.AccidentPolicyNumber   = paramAccidentPolicyNumber;
    }
    return self;
}
@end

@implementation EditableUserData

-(id)initWithUserFirstName: (NSString *)ParamUserFirstName
              UserlastName: (NSString *)ParamUserlastName
                 UsersEmail: (NSString *)ParamUserEmail
           UserPhoneNumber: (NSString *)ParamUserPhoneNumber
           UserDateOfBirth: (NSString *)ParamUserDateOfBirth
                UserGender: (NSString *)ParamUserGender
          UserPolicyNumber: (NSString *)ParamUserPolicyNumber
{
    self = [super init];
    if (self) {
        self.UserFirstName      = ParamUserFirstName;
        self.UserlastName       = ParamUserlastName;
        self.UsersEmail         = ParamUserEmail;
        self.UserPhoneNumber    = ParamUserPhoneNumber;
        self.UserDateOfBirth    = ParamUserDateOfBirth;
        self.UserGender         = ParamUserGender;
        self.UserPolicyNumber   = ParamUserPolicyNumber;
    }
    return self;
}

@end
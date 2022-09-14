unit IDocumentUnit;

interface

uses

  IGetSelfUnit,
  Employee,
  DomainException,
  DocumentChargeInterface,
  DocumentSignings,
  DocumentWorkCycle,
  DocumentApprovings;

type

  TDocumentException = class (TDomainException)

  end;
  
  IDocument = interface (IGetSelf)

      function GetIdentity: Variant;
      function GetKindIdentity: Variant;
      function GetContent: String;
      function GetCreationDate: TDateTime;
      function GetDocumentDate: Variant;
      function GetName: String;
      function GetNote: String;
      function GetProductCode: String;
      function GetNumber: String;
      function GetCurrentWorkCycleStageName: String;
      function GetCurrentWorkCycleStageNumber: Integer;
      function GetEditingEmployee: TEmployee;
      function GetAuthor: TEmployee;
      function GetDocumentCharges: IDocumentCharges;
      function GetDocumentSignings: TDocumentSignings;
      function GetDocumentApprovings: TDocumentApprovings;
      function GetIsRejectedFromSigning: Boolean;
      function GetIsPerformed: Boolean;
      function GetIsPerforming: Boolean;
      function GetIsSigned: Boolean;
      function GetIsSigning: Boolean;
      function GetIsSentToSigning: Boolean; 
      function GetIsApproving: Boolean;
      function GetIsApproved: Boolean;
      function GetIsNotApproved: Boolean;
      function GetResponsibleId: Variant;
      function GetAreAllApprovingsPerformed: Boolean;
      function GetIsSelfRegistered: Boolean;
      function GetIsNumberAssigned: Boolean;
      function GetWorkCycle: TDocumentWorkCycle;

      procedure SetIdentity(Identity: Variant);
      procedure SetKindIdentity(KindIdentity: Variant);
      procedure SetContent(const Value: String);
      procedure SetCreationDate(const Value: TDateTime);
      procedure SetDocumentDate(const Value: Variant);
      procedure SetName(const Value: String);
      procedure SetNote(const Value: String);
      procedure SetProductCode(const Value: String);
      procedure SetNumber(const Value: String);
      procedure SetCurrentWorkCycleStageNumber(const StageNumber: Integer);
      procedure SetCurrentWorkCycleStageName(const StageName: String);
      procedure SetResponsibleId(const Value: Variant);
      procedure SetAuthor(const Value: TEmployee);
      procedure SetEditingEmployee(Employee: TEmployee);
      procedure SetIsSelfRegistered(const Value: Boolean);
      procedure SetWorkCycle(const Value: TDocumentWorkCycle);
      
      procedure AddApprover(
        AddingEmployee: TEmployee;
        AddableEmployee: TEmployee
      );

      procedure RemoveApprover(
        RemovingEmployee: TEmployee;
        RemoveableEmployee: TEmployee
      );
      
      procedure RemoveAllApprovers(
        RemovingEmployee: TEmployee
      );

      procedure AddSigner(Employee: TEmployee);
      procedure RemoveSigner(Employee: TEmployee);
      procedure RemoveAllSigners;

      procedure ApproveBy(Employee: TEmployee; const Note: String = '');
      procedure ApproveByOnBehalfOf(
        CurrentApprovingEmployee: TEmployee;
        FormalApprover: TEmployee;
        const Note: String = ''
      );

      procedure ChangeNoteForApprover(
        ChangingEmployee: TEmployee;
        Approver: TEmployee;
        const Note: String
      );
      
      procedure RejectApprovingBy(Employee: TEmployee; const Reason: String = '');
      procedure RejectApprovingByOnBehalfOf(
        CurrentRejectingApprovingEmployee: TEmployee;
        FormalApprover: TEmployee;
        const Reason: String = ''
      );

      procedure MarkAsSignedForAllSigners(
        const MarkingEmployee: TEmployee;
        const SigningDate: TDateTime
      );
      
      procedure MarkAsSigned(
        const MarkingEmployee: TEmployee;
        const Signer: TEmployee;
        const SigningDate: TDateTime
      );
      
      procedure SignBy(Employee: TEmployee);
      procedure SignByOnBehalfOf(
        CurrentSigningEmployee: TEmployee;
        FormalSigner: TEmployee
      );

      procedure RejectSigningBy(Employee: TEmployee);
      procedure RejectSigningByBehalfOf(
        CurrentRejectingSigningEmployee: TEmployee;
        FormalSigner: TEmployee
      );

      function FindApprovingByFormalApprover(
        FormalApprover: TEmployee
      ): TDocumentApproving;
      
      function FindSigningBySignerOrActuallySignedEmployee(
        Employee: TEmployee
      ): TDocumentSigning;

      function IsSignedBy(Employee: TEmployee): Boolean;

      procedure AddCharge(Charge: IDocumentCharge);
      procedure AddCharges(Charges: IDocumentCharges);
      procedure ChangeCharge(Charge: IDocumentCharge);
      procedure ChangeCharges(Charges: IDocumentCharges);
      procedure RemoveChargeFor(Performer: TEmployee);
      procedure RemoveChargesFor(Performers: TEmployees);
      procedure PerformCharge(Charge: IDocumentCharge);

      function FindChargeByPerformerOrActuallyPerformedEmployee(
        Employee: TEmployee
      ): IDocumentCharge;

      function IsPerformedBy(Employee: TEmployee): Boolean;

      procedure ToSigningBy(Employee: TEmployee);
      procedure ToApprovingBy(Employee: TEmployee);
      procedure MarkAsApprovedBy(Employee: TEmployee);
      procedure MarkAsNotApprovedBy(Employee: TEmployee);
      procedure ToPerformingBy(Employee: TEmployee);

      function FetchAllApprovers: TEmployees;
      function FetchAllSigners: TEmployees;
      function FetchAllPerformers: TEmployees;

      property Identity: Variant read GetIdentity write SetIdentity;
      property KindIdentity: Variant read GetKindIdentity write SetKindIdentity;
      
      property Number: String read GetNumber write SetNumber;
      property Name: String read GetName write SetName;

      property CreationDate: TDateTime
      read GetCreationDate write SetCreationDate;

      property DocumentDate: Variant
      read GetDocumentDate write SetDocumentDate;

      property Content: String read GetContent write SetContent;
      property Note: String read GetNote write SetNote;

      property ProductCode: String read GetProductCode write SetProductCode;
      
      property ResponsibleId: Variant
      read GetResponsibleId write SetResponsibleId;

      property Author: TEmployee
      read GetAuthor write SetAuthor;

      property CurrentWorkCycleStageNumber: Integer
      read GetCurrentWorkCycleStageNumber
      write SetCurrentWorkCycleStageNumber;

      property CurrentWorkCycleStageName: String
      read GetCurrentWorkCycleStageName
      write SetCurrentWorkCycleStageName;

      property AreAllApprovingsPerformed:  Boolean
      read GetAreAllApprovingsPerformed;
      
      property IsApproving: Boolean read GetIsApproving;
      property IsApproved: Boolean read GetIsApproved;
      property IsNotApproved: Boolean read GetIsNotApproved;
      property IsSigning: Boolean read GetIsSigning;
      property IsSentToSigning: Boolean read GetIsSentToSigning;
      property IsSigned: Boolean read GetIsSigned;
      property IsPerforming: Boolean read GetIsPerforming;
      property IsPerformed: Boolean read GetIsPerformed;
      property IsRejectedFromSigning: Boolean read GetIsRejectedFromSigning;

      property Signings: TDocumentSignings read GetDocumentSignings;
      property Charges: IDocumentCharges read GetDocumentCharges;
      property Approvings: TDocumentApprovings read GetDocumentApprovings;

      property EditingEmployee: TEmployee
      read GetEditingEmployee write SetEditingEmployee;

      property IsSelfRegistered: Boolean
      read GetIsSelfRegistered write SetIsSelfRegistered;

      property IsNumberAssigned: Boolean
      read GetIsNumberAssigned;

      property WorkCycle: TDocumentWorkCycle
      read GetWorkCycle write SetWorkCycle;

  end;
  
implementation

end.

unit EmployeeDocumentWorkingRules;

interface

uses

  EmployeeDocumentWorkingRule,
  DocumentChargeListChangingRule,
  DocumentSignerListChangingRule,
  DocumentPerformingRule,
  DocumentSigningPerformingRule,
  DocumentApproverListChangingRule,
  DocumentApprovingPerformingRule,
  DocumentApprovingRejectingPerformingRule,
  DocumentSigningRejectingPerformingRule,
  DocumentSigningMarkingRule,
  DocumentDraftingRule,
  DocumentRemovingRule,
  DomainObjectValueUnit,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IEmployeeDocumentWorkingRules = interface (IGetSelf)
    ['{F5B93701-D677-4E00-9114-E199D917D0F4}']
    
  end;

  TEmployeeDocumentWorkingRules =
    class (TInterfacedObject, IEmployeeDocumentWorkingRules)

      private

        FDocumentViewingRule: IEmployeeDocumentWorkingRule;
        FDocumentRemovingRule: IDocumentRemovingRule;
        FSigningPerformingRule: IDocumentSigningPerformingRule;
        FSigningRejectingPerformingRule: IDocumentSigningRejectingPerformingRule;
        FSigningDocumentSendingRule: IEmployeeDocumentWorkingRule;
        FPerformingDocumentSendingRule: IEmployeeDocumentWorkingRule;
        FApproverListChangingRule: IDocumentApproverListChangingRule;
        FApprovingPerformingRule: IDocumentApprovingPerformingRule;
        FApprovingRejectingPerformingRule: IDocumentApprovingRejectingPerformingRule;
        FApprovingDocumentSendingRule: IEmployeeDocumentWorkingRule;
        FApprovingPassingMarkingRule: IEmployeeDocumentWorkingRule;
        FSignerListChangingRule: IDocumentSignerListChangingRule;
        FPerformingRule: IDocumentPerformingRule;
        FChargeListChangingRule: IDocumentChargeListChangingRule;
        FDraftingRule: IDocumentDraftingRule;
        FEditingRule: IEmployeeDocumentWorkingRule;
        FAsSelfRegisteredDocumentMarkingRule: IEmployeeDocumentWorkingRule;
        FDocumentSigningMarkingRule: IDocumentSigningMarkingRule;

      public

        destructor Destroy; override;
        constructor Create; overload;

        constructor Create(
          DocumentViewingRule: IEmployeeDocumentWorkingRule;
          DocumentRemovingRule: IDocumentRemovingRule;
          ApproverListChangingRule: IDocumentApproverListChangingRule;
          ApprovingPerformingRule: IDocumentApprovingPerformingRule;
          ApprovingRejectingPerformingRule: IDocumentApprovingRejectingPerformingRule;
          ApprovingDocumentSendingRule: IEmployeeDocumentWorkingRule;
          ApprovingPassingMarkingRule: IEmployeeDocumentWorkingRule;
          SigningPerformingRule: IDocumentSigningPerformingRule;
          SigningRejectingPerformingRule: IDocumentSigningRejectingPerformingRule;
          SigningDocumentSendingRule: IEmployeeDocumentWorkingRule;
          PerformingDocumentSendingRule: IEmployeeDocumentWorkingRule;
          SignerListChangingRule: IDocumentSignerListChangingRule;
          PerformingRule: IDocumentPerformingRule;
          ChargeListChangingRule: IDocumentChargeListChangingRule;
          DraftingRule: IDocumentDraftingRule;
          EditingRule: IEmployeeDocumentWorkingRule;
          AsSelfRegisteredDocumentMarkingRule: IEmployeeDocumentWorkingRule;
          DocumentSigningMarkingRule: IDocumentSigningMarkingRule
        ); overload;

        constructor CreateFromOther(
          EmployeeDocumentWorkingRules: TEmployeeDocumentWorkingRules
        );

        function GetSelf: TObject;

      published

        property Self: TObject read GetSelf;
        
        property DocumentViewingRule: IEmployeeDocumentWorkingRule
        read FDocumentViewingRule write FDocumentViewingRule;

        property DocumentRemovingRule: IDocumentRemovingRule
        read FDocumentRemovingRule write FDocumentRemovingRule;
        
        property SigningPerformingRule: IDocumentSigningPerformingRule
        read FSigningPerformingRule write FSigningPerformingRule;

        property SigningRejectingPerformingRule:
          IDocumentSigningRejectingPerformingRule
        read FSigningRejectingPerformingRule
        write FSigningRejectingPerformingRule;

        property SigningDocumentSendingRule: IEmployeeDocumentWorkingRule
        read FSigningDocumentSendingRule
        write FSigningDocumentSendingRule;

        property PerformingDocumentSendingRule: IEmployeeDocumentWorkingRule
        read FPerformingDocumentSendingRule
        write FPerformingDocumentSendingRule;

        property ApproverListChangingRule: IDocumentApproverListChangingRule
        read FApproverListChangingRule write FApproverListChangingRule;

        property ApprovingPerformingRule: IDocumentApprovingPerformingRule
        read FApprovingPerformingRule write FApprovingPerformingRule;

        property ApprovingRejectingPerformingRule: IDocumentApprovingRejectingPerformingRule
        read FApprovingRejectingPerformingRule write FApprovingRejectingPerformingRule;

        property ApprovingDocumentSendingRule: IEmployeeDocumentWorkingRule
        read FApprovingDocumentSendingRule write FApprovingDocumentSendingRule;

        property ApprovingPassingMarkingRule: IEmployeeDocumentWorkingRule
        read FApprovingPassingMarkingRule write FApprovingPassingMarkingRule;
        
        property SignerListChangingRule: IDocumentSignerListChangingRule
        read FSignerListChangingRule write FSignerListChangingRule;

        property PerformingRule: IDocumentPerformingRule
        read FPerformingRule write FPerformingRule;

        property ChargeListChangingRule: IDocumentChargeListChangingRule
        read FChargeListChangingRule write FChargeListChangingRule;

        property DraftingRule: IDocumentDraftingRule
        read FDraftingRule write FDraftingRule;

        property EditingRule: IEmployeeDocumentWorkingRule
        read FEditingRule write FEditingRule;

        property AsSelfRegisteredDocumentMarkingRule:
          IEmployeeDocumentWorkingRule
        read FAsSelfRegisteredDocumentMarkingRule
        write FAsSelfRegisteredDocumentMarkingRule;

        property DocumentSigningMarkingRule: IDocumentSigningMarkingRule
        read FDocumentSigningMarkingRule write FDocumentSigningMarkingRule;

    end;

implementation

{ TEmployeeDocumentWorkingRules }

constructor TEmployeeDocumentWorkingRules.Create(
  DocumentViewingRule: IEmployeeDocumentWorkingRule;
  DocumentRemovingRule: IDocumentRemovingRule;
  ApproverListChangingRule: IDocumentApproverListChangingRule;
  ApprovingPerformingRule: IDocumentApprovingPerformingRule;
  ApprovingRejectingPerformingRule: IDocumentApprovingRejectingPerformingRule;
  ApprovingDocumentSendingRule: IEmployeeDocumentWorkingRule;
  ApprovingPassingMarkingRule: IEmployeeDocumentWorkingRule;
  SigningPerformingRule: IDocumentSigningPerformingRule;
  SigningRejectingPerformingRule: IDocumentSigningRejectingPerformingRule;
  SigningDocumentSendingRule: IEmployeeDocumentWorkingRule;
  PerformingDocumentSendingRule: IEmployeeDocumentWorkingRule;
  SignerListChangingRule: IDocumentSignerListChangingRule;
  PerformingRule: IDocumentPerformingRule;
  ChargeListChangingRule: IDocumentChargeListChangingRule;
  DraftingRule: IDocumentDraftingRule;
  EditingRule: IEmployeeDocumentWorkingRule;
  AsSelfRegisteredDocumentMarkingRule: IEmployeeDocumentWorkingRule;
  DocumentSigningMarkingRule: IDocumentSigningMarkingRule
);
begin

  inherited Create;

  FDocumentViewingRule := DocumentViewingRule;
  FDocumentRemovingRule := DocumentRemovingRule;
  FApproverListChangingRule := ApproverListChangingRule;
  FApprovingPerformingRule := ApprovingPerformingRule;
  FApprovingRejectingPerformingRule := ApprovingRejectingPerformingRule;
  FApprovingDocumentSendingRule := ApprovingDocumentSendingRule;
  FApprovingPassingMarkingRule := ApprovingPassingMarkingRule;
  FSigningPerformingRule := SigningPerformingRule;
  FSigningRejectingPerformingRule := SigningRejectingPerformingRule;
  FSigningDocumentSendingRule := SigningDocumentSendingRule;
  FPerformingDocumentSendingRule := PerformingDocumentSendingRule;
  FSignerListChangingRule := SignerListChangingRule;
  FPerformingRule := PerformingRule;
  FChargeListChangingRule := ChargeListChangingRule;
  FDraftingRule := DraftingRule;
  FEditingRule := EditingRule;
  FAsSelfRegisteredDocumentMarkingRule := AsSelfRegisteredDocumentMarkingRule;
  FDocumentSigningMarkingRule := DocumentSigningMarkingRule;

end;

constructor TEmployeeDocumentWorkingRules.CreateFromOther(
  EmployeeDocumentWorkingRules: TEmployeeDocumentWorkingRules);
begin

  inherited Create;

  FDocumentViewingRule := EmployeeDocumentWorkingRules.DocumentViewingRule;
  FApproverListChangingRule := EmployeeDocumentWorkingRules.ApproverListChangingRule;
  FApprovingPerformingRule := EmployeeDocumentWorkingRules.ApprovingPerformingRule;
  FApprovingRejectingPerformingRule := EmployeeDocumentWorkingRules.ApprovingRejectingPerformingRule;
  FApprovingDocumentSendingRule := EmployeeDocumentWorkingRules.ApprovingDocumentSendingRule;
  FApprovingPassingMarkingRule := EmployeeDocumentWorkingRules.ApprovingPassingMarkingRule;
  FSigningPerformingRule := EmployeeDocumentWorkingRules.SigningPerformingRule;
  FSigningRejectingPerformingRule := EmployeeDocumentWorkingRules.SigningRejectingPerformingRule;
  FSigningDocumentSendingRule := EmployeeDocumentWorkingRules.SigningDocumentSendingRule;
  FPerformingDocumentSendingRule := EmployeeDocumentWorkingRules.PerformingDocumentSendingRule;
  FSignerListChangingRule := EmployeeDocumentWorkingRules.SignerListChangingRule;
  FPerformingRule := EmployeeDocumentWorkingRules.PerformingRule;
  FChargeListChangingRule := EmployeeDocumentWorkingRules.ChargeListChangingRule;
  FEditingRule := EmployeeDocumentWorkingRules.EditingRule;
  FAsSelfRegisteredDocumentMarkingRule := EmployeeDocumentWorkingRules.AsSelfRegisteredDocumentMarkingRule;
  
end;

destructor TEmployeeDocumentWorkingRules.Destroy;
begin

  inherited;

end;

function TEmployeeDocumentWorkingRules.GetSelf: TObject;
begin

  Result := Self;
  
end;

constructor TEmployeeDocumentWorkingRules.Create;
begin

  inherited;
  
end;

end.

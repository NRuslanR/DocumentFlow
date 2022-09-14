unit PersonnelOrderSigningRejectingRule;

interface

uses

  StandardEmployeeDocumentSigningRejectingPerformingRule,
  PersonnelOrderControlService,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  DomainException,
  IDocumentUnit,
  PersonnelOrder,
  Employee,
  SysUtils;

type

  TPersonnelOrderSigningRejectingRuleException =
    class (TDomainException)

    end;
    
  TPersonnelOrderSigningRejectingRule =
    class (TStandardEmployeeDocumentSigningRejectingPerformingRule)

      private

        FPersonnelOrderControlService: IPersonnelOrderControlService;

      protected

        function GetRealFormalSignerForRejectingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigningRejecting(
          Document: IDocument;
          FormalSigner: TEmployee;
          RejectingEmployee: TEmployee
        ): TEmployee; override;

      public

        constructor Create(

          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;
            
          PersonnelOrderControlService: IPersonnelOrderControlService

        );

    end;

implementation

{ TPersonnelOrderSigningRejectingRule }

constructor TPersonnelOrderSigningRejectingRule.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
  PersonnelOrderControlService: IPersonnelOrderControlService
);
begin

  inherited Create(
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    DocumentFullNameCompilationService
  );

  FPersonnelOrderControlService := PersonnelOrderControlService;

end;

function TPersonnelOrderSigningRejectingRule.
  GetRealFormalSignerForRejectingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigningRejecting(
    Document: IDocument; FormalSigner, RejectingEmployee: TEmployee
  ): TEmployee;
var
    PersonnelOrder: TPersonnelOrder;
begin

  PersonnelOrder := Document.Self as TPersonnelOrder;
  
  try

    FPersonnelOrderControlService.EnsureEmployeeMayControlPersonnelOrders(
      PersonnelOrder.SubKindId, RejectingEmployee
    );

    Result := RejectingEmployee;
    
  except

    on E: TDomainException do begin

      Raise TPersonnelOrderSigningRejectingRuleException.Create(
        'Подписание кадрового приказа не может ' +
        'быть оклонено, поскольку: ' + sLineBreak +
        E.Message
      );

    end;

  end;

end;

end.

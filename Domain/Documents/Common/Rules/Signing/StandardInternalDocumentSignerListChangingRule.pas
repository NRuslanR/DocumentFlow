unit StandardInternalDocumentSignerListChangingRule;

interface

uses

  StandardDocumentSignerListChangingRule,
  DocumentSignerListChangingRule,
  Employee,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TStandardInternalDocumentSignerListChangingRule =
    class (TStandardEmployeeDocumentSignerListChangingRule)

      protected

        procedure RaiseSignerAssigningExceptionIfSignerIsNotLeaderForAssigningEmployee(
          Signer: TEmployee;
          Document: IDocument;
          AssigningEmployee: TEmployee
        ); override;
      
    end;
  
implementation

{ TStandardInternalDocumentSignerListChangingRule }

procedure TStandardInternalDocumentSignerListChangingRule.
  RaiseSignerAssigningExceptionIfSignerIsNotLeaderForAssigningEmployee(
    Signer: TEmployee;
    Document: IDocument;
    AssigningEmployee: TEmployee
  );
begin

  if
    not (
      FEmployeeIsLeaderForOtherSpecification.
        IsEmployeeSameHeadKindredDepartmentDirectLeaderForOtherEmployee(
          Signer, AssigningEmployee
        )

      or

      IsEmployeeWorkGroupLeaderForOtherEmployee(
        Signer, AssigningEmployee
      )
    )
  then begin

    raise TDocumentSignerListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не может указать сотрудника "%s" ' +
      'подписантом внутреннего документа, поскольку он ' +
      'не является для него непосредственным руководителем',
      [
        AssigningEmployee.FullName,
        Signer.FullName
      ]
    );

  end;
  
end;

end.

unit StandardDocumentChargeSheetRemovingService;

interface

uses

  DocumentChargeSheetRemovingService,
  DocumentChargeSheet,
  DocumentChargeSheetDirectory,
  Employee,
  DomainException,
  IDocumentChargeSheetUnit,
  SysUtils;

type

  TStandardDocumentChargeSheetRemovingService =
    class (TInterfacedObject, IDocumentChargeSheetRemovingService)

      protected

        FChargeSheetDirectory: IDocumentChargeSheetDirectory;

      public

        constructor Create(
          ChargeSheetDirectory: IDocumentChargeSheetDirectory
        );
        
        procedure RemoveChargeSheets(
          Employee: TEmployee;
          ChargeSheets: TDocumentChargeSheets
        );

    end;

implementation

uses

  StrUtils,
  AuxDebugFunctionsUnit,
  DocumentChargeSheetRemovingRule;
  
{ TStandardDocumentChargeSheetRemovingService }

constructor TStandardDocumentChargeSheetRemovingService.Create(
  ChargeSheetDirectory: IDocumentChargeSheetDirectory);
begin

  inherited Create;

  FChargeSheetDirectory := ChargeSheetDirectory;
  
end;

procedure TStandardDocumentChargeSheetRemovingService.RemoveChargeSheets(
  Employee: TEmployee;
  ChargeSheets: TDocumentChargeSheets
);
var
    ChargeSheet: IDocumentChargeSheet;
    ChargeSheetObj: TDocumentChargeSheet;
    
    AllowableForRemovingChargeSheets: TDocumentChargeSheets;
    FreeAllowableForRemovingChargeSheets: IDocumentChargeSheets;

    NotAllowableForRemovingChargeSheets: TDocumentChargeSheets;
    FreeNotAllowableForRemovingChargeSheets: IDocumentChargeSheets;

    AllChargeSheetsForRemoving: TDocumentChargeSheets;
    FreeAllChargeSheetsForRemoving: IDocumentChargeSheets;
    
    IssuerSubordinateChargeSheets: TDocumentChargeSheets;
    FreeIssuerSubordinateChargeSheets: IDocumentChargeSheets;

    IssuerSubordinateChargeSheetCount: Integer;
begin

  AllowableForRemovingChargeSheets := TDocumentChargeSheets.Create;
  FreeAllowableForRemovingChargeSheets := AllowableForRemovingChargeSheets;

  NotAllowableForRemovingChargeSheets := TDocumentChargeSheets.Create;
  FreeNotAllowableForRemovingChargeSheets := NotAllowableForRemovingChargeSheets;

  for ChargeSheet in ChargeSheets do begin

    try

      ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);
      
      ChargeSheetObj
        .WorkingRules
          .DocumentChargeSheetRemovingRule
            .EnsureThatIsSatisfiedFor(Employee, ChargeSheetObj);

      AllowableForRemovingChargeSheets.AddDocumentChargeSheet(ChargeSheet);

    except

      on E: TDocumentChargeSheetRemovingRuleException do begin

        NotAllowableForRemovingChargeSheets.AddDocumentChargeSheet(ChargeSheet);
        
      end;

    end;

  end;

  AllChargeSheetsForRemoving := TDocumentChargeSheets.Create;

  FreeAllChargeSheetsForRemoving := AllChargeSheetsForRemoving;

  AllChargeSheetsForRemoving.AddDocumentChargeSheets(AllowableForRemovingChargeSheets);

  if not NotAllowableForRemovingChargeSheets.IsEmpty then begin

    IssuerSubordinateChargeSheetCount := 0;

    for ChargeSheet in AllowableForRemovingChargeSheets do begin

      IssuerSubordinateChargeSheets :=
        NotAllowableForRemovingChargeSheets.
          FindAllSubordinateChargeSheetsByIssuer(
            ChargeSheet.Performer
          );

      FreeIssuerSubordinateChargeSheets :=
        IssuerSubordinateChargeSheets;

      AllChargeSheetsForRemoving.AddDocumentChargeSheets(IssuerSubordinateChargeSheets);
      
      Inc(
        IssuerSubordinateChargeSheetCount,
        IssuerSubordinateChargeSheets.Count
      );

    end;

    {
      refactor:
        create aggregate exception to hold list of exception
        per fail removed charge sheet
    }
    if IssuerSubordinateChargeSheetCount <> NotAllowableForRemovingChargeSheets.Count
    then begin

      raise TDocumentChargeSheetRemovingServiceException.CreateFmt(
        'Сотрудник "%s" не может отозвать' +
        IfThen(not AllowableForRemovingChargeSheets.IsEmpty, ' некоторые ', ' ') +
        'поручения по следующим возможным причинам:' + sLineBreak +
        '1 - отсутствие соответствующих прав' + sLineBreak +
        '2 - недопустимый статус поручений - выполнено' + sLineBreak +
        '3 - недопустимый статус документа',
        [
          Employee.FullName
        ]
      );

    end;

  end;

  FChargeSheetDirectory.RemoveDocumentChargeSheetsWithAllSubordinates(
    AllChargeSheetsForRemoving
  );

end;

end.

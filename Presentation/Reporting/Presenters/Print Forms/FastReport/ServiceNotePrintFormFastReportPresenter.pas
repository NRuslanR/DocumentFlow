{ refactor: extract common implementation to ancestor class TDocumentPrintFormPresenter }

unit ServiceNotePrintFormFastReportPresenter;

interface

uses

  DocumentPrintFormPresenter,
  DocumentCardFormViewModel,
  SysUtils,
  DocumentApprovingListSetHolder,
  DocumentChargeSetHolder,
  frxDocumentPrintFormReportsModule,
  DocumentApprovingListRecordSetHolder,
  frxClass,
  Classes;

type

  TServiceNotePrintFormFastReportPresenter =
    class (TInterfacedObject, IDocumentPrintFormPresenter)

      private

        type

          TReceiversKind = (rkPerformers, rkAcquainters);
          
      private

        FDocumentPrintFormReportsModule: TfrxDocumentPrintFormReports;
        
      private

        function MakeFormalEmployeeNameFrom(
          const EmployeeName: String;
          const UsePadeg: Boolean = False
        ): String;
        
        function CreateReceiverInfoListString(
          DocumentChargeSetInfoHolder:
            TDocumentChargeSetHolder;
          const ReceiversKind: TReceiversKind
        ): String;

        function CreatePerformerInfoListString(
          DocumentChargeSetInfoHolder:
            TDocumentChargeSetHolder
        ): String;

        function CreateAcquainterInfoListString(
          DocumentChargeSetInfoHolder:
            TDocumentChargeSetHolder
        ): String;

        procedure FillReportByDocumentCardViewModel(
          Report: TfrxReport;
          DocumentCardViewModel: TDocumentCardFormViewModel
        ); virtual;

        procedure FillReportByDocumentApprovingListSetHolder(
          Report: TfrxReport;
          DocumentApprovingListSetHolder: TDocumentApprovingListSetHolder
        ); virtual;

      public

        destructor Destroy; override;
        constructor Create;
        
        procedure PresentDocumentPrintFormBy(
          DocumentCardViewModel: TDocumentCardFormViewModel
        ); overload;

        procedure PresentDocumentPrintFormBy(
          DocumentCardViewModel: TDocumentCardFormViewModel;
          DocumentApprovingListSetHolder: TDocumentApprovingListSetHolder
        ); overload;

    end;

implementation

uses

  DB,
  DateUtils,
  Variants,
  AuxDebugFunctionsUnit,
  AuxiliaryStringFunctions,
  PadegImports,
  StrUtils,
  dxmdaset;

{ TServiceNotePrintFormFastReportPresenter }

constructor TServiceNotePrintFormFastReportPresenter.Create;
begin

  inherited;

  FDocumentPrintFormReportsModule := TfrxDocumentPrintFormReports.Create(nil);
  
end;

function TServiceNotePrintFormFastReportPresenter.CreateAcquainterInfoListString(
  DocumentChargeSetInfoHolder: TDocumentChargeSetHolder): String;
begin

  Result :=
    CreateReceiverInfoListString(
      DocumentChargeSetInfoHolder,
      rkAcquainters
    );

end;

function TServiceNotePrintFormFastReportPresenter.CreatePerformerInfoListString(
  DocumentChargeSetInfoHolder: TDocumentChargeSetHolder): String;
begin

  Result :=
    CreateReceiverInfoListString(
      DocumentChargeSetInfoHolder,
      rkPerformers
    );

end;

function TServiceNotePrintFormFastReportPresenter.
  CreateReceiverInfoListString(
    DocumentChargeSetInfoHolder:
      TDocumentChargeSetHolder;
    const ReceiversKind: TReceiversKind
  ): String;
var DocumentChargeSet: TDataSet;
    ReceiverInfo: String;
    PadegSpecialityLength: Integer;
    PadegSpeciality: PChar;
    ReceiverSpeciality: String;
    IsReceiversKindSatisfied: Boolean;
begin

  DocumentChargeSet :=
    DocumentChargeSetInfoHolder.DataSet;
    
  try

    DocumentChargeSet.DisableControls;

    DocumentChargeSet.First;

    while not DocumentChargeSet.Eof do begin

      if not VarIsNull(DocumentChargeSetInfoHolder.TopLevelChargeIdFieldValue)
      then begin

        DocumentChargeSet.Next;
        Continue;

      end;

      IsReceiversKindSatisfied :=
        DocumentChargeSetInfoHolder.IsChargeForAcquaitanceFieldValue;

      if ReceiversKind = rkPerformers then
        IsReceiversKindSatisfied := not IsReceiversKindSatisfied;

      if not IsReceiversKindSatisfied then begin

        DocumentChargeSet.Next;
        Continue;
        
      end;
      
      PadegSpecialityLength :=
        Length(DocumentChargeSetInfoHolder.ReceiverSpecialityFieldValue) + 10;

      PadegSpeciality := StrAlloc(PadegSpecialityLength);
      
      if GetAppointmentPadeg(
          PChar(DocumentChargeSetInfoHolder.ReceiverSpecialityFieldValue),
          3,
          PadegSpeciality,
          PadegSpecialityLength
        ) = 0
      then ReceiverSpeciality := String(PadegSpeciality)
      else ReceiverSpeciality := DocumentChargeSetInfoHolder.ReceiverSpecialityFieldValue;

      ReceiverInfo :=
        ReceiverSpeciality +
        sLineBreak +
        MakeFormalEmployeeNameFrom(
          DocumentChargeSetInfoHolder.ReceiverFullNameFieldValue,
          True
        );

      StrDispose(PadegSpeciality);
      
      if Result = '' then
        Result := ReceiverInfo

      else Result := Result + sLineBreak + sLineBreak + ReceiverInfo;
      
      DocumentChargeSet.Next;


    end;

    DocumentChargeSet.First;

  finally

    DocumentChargeSet.EnableControls;

  end;
  
end;

destructor TServiceNotePrintFormFastReportPresenter.Destroy;
begin

  FreeAndNil(FDocumentPrintFormReportsModule);
  
  inherited;

end;


procedure TServiceNotePrintFormFastReportPresenter.
  FillReportByDocumentApprovingListSetHolder(
    Report: TfrxReport;
    DocumentApprovingListSetHolder: TDocumentApprovingListSetHolder
  );
begin

  with FDocumentPrintFormReportsModule, DocumentApprovingListSetHolder do begin

    DocumentApprovingListRecordSet.EmptyDataSet;
    DocumentApprovingListSet.EmptyDataSet;
    
    if DocumentApprovingListSetHolder.IsEmpty then Exit;

    if not DocumentApprovingListSet.Active then
      DocumentApprovingListSet.Open;

    if not DocumentApprovingListRecordSet.Active then
      DocumentApprovingListRecordSet.Open;

    while not Eof do begin

      DocumentApprovingListSet.AppendRecord([TitleFieldValue]);

      ApprovingListRecordSetHolder.FilterByListTitleField(TitleFieldValue);

      ApprovingListRecordSetHolder.First;

      while not ApprovingListRecordSetHolder.Eof do begin

        DocumentApprovingListRecordSet.AppendRecord(
          [
            TitleFieldValue,
            ApprovingListRecordSetHolder.ApproverSpecialityFieldValue,
            ApprovingListRecordSetHolder.ApprovingPerformingResultFieldValue,
            MakeFormalEmployeeNameFrom(
              ApprovingListRecordSetHolder.ApproverNameFieldValue
            )
          ]
        );

        ApprovingListRecordSetHolder.Next;

      end;

      Next;
      
    end;

  end;

  DocumentApprovingListSetHolder.First;
  DocumentApprovingListSetHolder.ApprovingListRecordSetHolder.First;
  
end;

procedure TServiceNotePrintFormFastReportPresenter.
  FillReportByDocumentCardViewModel(
    Report: TfrxReport;
    DocumentCardViewModel: TDocumentCardFormViewModel
  );
var
    PerformerInfoList, AcquainterInfoList: String;
    ContentFieldDef: TFieldDef;
begin

  Report.Variables['DepartmentFullName'] :=
    '''' +
    DocumentCardViewModel.
      DocumentMainInformationFormViewModel.
        DocumentSignerViewModel.DepartmentShortName +
    '''';

  Report.Variables['ServiceNoteNumber'] :=
        '''' +
        DocumentCardViewModel.
          DocumentMainInformationFormViewModel.Number +
        '''';

  Report.Variables['ServiceNoteDate'] :=
        DateOf(
          DocumentCardViewModel.
            DocumentMainInformationFormViewModel.
              DocumentDate
        );

  FDocumentPrintFormReportsModule.ContentDataSet.Edit;
      
  FDocumentPrintFormReportsModule.
      ContentDataSet.FieldByName('content').AsString :=
        DocumentCardViewModel.DocumentMainInformationFormViewModel.Content;

  FDocumentPrintFormReportsModule.ContentDataSet.Post;
      
  Report.Variables['LeaderSpeciality'] :=
        '''' +
        DocumentCardViewModel.
          DocumentMainInformationFormViewModel.
            DocumentSignerViewModel.Speciality +
        '''';

  Report.Variables['LeaderFullName'] :=
        '''' +
        MakeFormalEmployeeNameFrom(
          DocumentCardViewModel.
            DocumentMainInformationFormViewModel.
              DocumentSignerViewModel.Name
        ) +
        '''';

  if DocumentCardViewModel.
            DocumentMainInformationFormViewModel.
              ActualSignerName <> ''
  then begin

        Report.Variables['ProgrammaticalySignedLabel'] :=
          '''' +
          'подписано  в СЭД' +
          '''';
          
  end

  else begin

    Report.Variables['ProgrammaticalySignedLabel'] := '''' + ' ' + '''';
    
  end;

  Report.Variables['PerformerFullName'] :=
        '''' +
        MakeFormalEmployeeNameFrom(
          DocumentCardViewModel.
            DocumentMainInformationFormViewModel.
              DocumentResponsibleViewModel.Name
        ) +
        '''';

  Report.Variables['PerformerTelephoneNumber'] :=
        '''' +
        DocumentCardViewModel.
          DocumentMainInformationFormViewModel.
            DocumentResponsibleViewModel.TelephoneNumber +
        '''';

  PerformerInfoList :=
    CreatePerformerInfoListString(
      DocumentCardViewModel.
        DocumentChargesFormViewModel.
          DocumentChargeSetHolder
    );

  if PerformerInfoList <> '' then begin

    Report.Variables['PerformerInfoList'] :=
      PerformerInfoList;

  end

  else Report.Variables['PerformerInfoList'] := '''' + ' ' + '''';

  AcquainterInfoList :=
    CreateAcquainterInfoListString(
      DocumentCardViewModel.
        DocumentChargesFormViewModel.
          DocumentChargeSetHolder
    );

  if AcquainterInfoList <> '' then begin

    Report.Variables['ForAcquaintanceLabel'] := '''' + 'Копия:' + '''';
    Report.Variables['AcquainterInfoList'] :=
      AcquainterInfoList;

  end

  else begin

    Report.Variables['ForAcquaintanceLabel'] := '''' + ' ' + '''';
    Report.Variables['AcquainterInfoList'] := '''' + ' ' + '''';
    
  end;

end;

function TServiceNotePrintFormFastReportPresenter.MakeFormalEmployeeNameFrom(
  const EmployeeName: String;
  const UsePadeg: Boolean
): String;
var FullNameParts: TStrings;
    Name, Family, Patronymic: String;
    FamilyFirstLetter, FamilyRestLetters: String;
    var PadegFullName: PChar; PadegFullNameLength: Integer;
    PadegResult: Integer;
begin

  FullNameParts := SplitStringByDelimiter(EmployeeName, ' ');

  if FullNameParts.Count <> 3 then begin
  
    raise Exception.Create(
            'При формировании печатной формы ' +
            'документа обнаружено ' +
            'некорректное имя сотрудника'
          );

  end;

  if UsePadeg then begin

    PadegFullNameLength := Length(EmployeeName) + 10;

    PadegFullName := StrAlloc(PadegFullNameLength);
    
    PadegResult :=
      GetFIOPadegAS(
        PChar(FullNameParts[0]),
        PChar(FullNameParts[1]),
        PChar(FullNameParts[2]),
        3,
        PadegFullName,
        PadegFullNameLength
      );

    if PadegResult = 0 then begin

      FullNameParts.Free;

      FullNameParts := SplitStringByDelimiter(String(PadegFullName), ' ');

    end;

    StrDispose(PadegFullName);

  end;

  Family := AnsiLowerCase(PChar(FullNameParts[0]));
  Name := FullNameParts[1];
  Patronymic := FullNameParts[2];

  FamilyFirstLetter := AnsiUpperCase(PChar(String(Family[1])));
  FamilyRestLetters := Copy(Family, 2, Length(Family) - 1);

  Result :=
    UpperCase(String(Name[1])) + '.' +
    UpperCase(String(Patronymic[1])) + '. ' +
    FamilyFirstLetter + FamilyRestLetters;

end;

procedure TServiceNotePrintFormFastReportPresenter.
  PresentDocumentPrintFormBy(
    DocumentCardViewModel: TDocumentCardFormViewModel;
    DocumentApprovingListSetHolder: TDocumentApprovingListSetHolder
  );
var DocumentPrintFormReport: TfrxReport;
begin

  DocumentPrintFormReport :=
    FDocumentPrintFormReportsModule.ServiceNotePrintFormReport;

  FillReportByDocumentCardViewModel(
    DocumentPrintFormReport, DocumentCardViewModel
  );

  FillReportByDocumentApprovingListSetHolder(
    DocumentPrintFormReport, DocumentApprovingListSetHolder
  );

  DocumentPrintFormReport.ShowReport;
  
end;

procedure TServiceNotePrintFormFastReportPresenter.PresentDocumentPrintFormBy(
  DocumentCardViewModel: TDocumentCardFormViewModel
);
var DocumentPrintFormReport: TfrxReport;
begin

  DocumentPrintFormReport :=
    FDocumentPrintFormReportsModule.ServiceNotePrintFormReport;

  FillReportByDocumentCardViewModel(
    DocumentPrintFormReport, DocumentCardViewModel
  );
  
  DocumentPrintFormReport.ShowReport;

end;

end.

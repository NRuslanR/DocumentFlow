unit DocumentTypesPanelController;

interface

uses

  UIDocumentKinds,
  EmployeeDocumentWorkStatistics,
  UIDocumentKindResolver,
  UINativeDocumentKindResolver,
  DocumentKindsFormViewModelMapper,
  DocumentKindsFormViewModel,
  GlobalDocumentKindDto,
  DocumentKindSetHolder,
  Controls,
  cxDBTL,
  SysUtils,
  Classes;

type

  TDocumentTypesPanelController = class

    protected

      FUIDocumentKindResolver: IUIDocumentKindResolver;
      FUINativeDocumentKindResolver: IUINativeDocumentKindResolver;
      FDocumentKindsFormViewModelMapper: TDocumentKindsFormViewModelMapper;

    private

      procedure SetDocumentKindTreeListLayoutIfNecessary(
        DocumentFlowPrimaryScreen: TWinControl;
        const DocumentKindSetFieldDefs: TDocumentKindSetFieldDefs
      );

    public

      destructor Destroy; override;
      
      constructor Create(
        DocumentKindsFormViewModelMapper: TDocumentKindsFormViewModelMapper
      );

      procedure SetEmployeeDocumentWorkStatistics(
        DocumentFlowPrimaryScreen: TWinControl;
        EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList
      );

      procedure ShowLoadingEmployeeDocumentWorkStatisticsLabel(
        DocumentFlowPrimaryScreen: TWinControl;
        const LoadingStatisticsLabel: String
      );

      procedure ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
        DocumentFlowPrimaryScreen: TWinControl;
        DocumentKind: TUIDocumentKindClass;
        const LoadingStatisticsLabel: String
      );

    public

      procedure FillDocumentKindsControlFrom(
        DocumentFlowPrimaryScreen: TWinControl;
        GlobalDocumentKindDtos: TGlobalDocumentKindDtos
      );
      
    public

      property UIDocumentKindResolver: IUIDocumentKindResolver
      read FUIDocumentKindResolver write FUIDocumentKindResolver;

      property UINativeDocumentKindResolver: IUINativeDocumentKindResolver
      read FUINativeDocumentKindResolver write FUINativeDocumentKindResolver;
      
  end;
  
implementation

uses

  Variants,
  cxTL,
  DocumentFlowWorkingFormUnit;
  
{ TDocumentTypesPanelController }

constructor TDocumentTypesPanelController.Create(
  DocumentKindsFormViewModelMapper: TDocumentKindsFormViewModelMapper
);
begin

  inherited Create;

  FDocumentKindsFormViewModelMapper := DocumentKindsFormViewModelMapper;
  
end;

procedure TDocumentTypesPanelController.SetDocumentKindTreeListLayoutIfNecessary(
  DocumentFlowPrimaryScreen: TWinControl;
  const DocumentKindSetFieldDefs: TDocumentKindSetFieldDefs
);

  procedure ChangeDocumentKindTreeListColumnIfNecessary(
    Column: TcxDBTreeListColumn;
    const FieldName: String;
    const ColumnCaption: String;
    const ColumnVisible: Boolean = True
  );
  begin

    with TDocumentFlowWorkingForm(DocumentFlowPrimaryScreen).DocumentKindTreeList
    do begin

      if Assigned(GetColumnByFieldName(FieldName)) then Exit;
      
      with Column do begin

        Caption.Text := ColumnCaption;
        DataBinding.FieldName := FieldName;
        Visible := ColumnVisible;
        Width := ClientWidth - 20;

      end;

    end;

  end;

begin

  with
    TDocumentFlowWorkingForm(DocumentFlowPrimaryScreen),
    DocumentKindTreeList,
    DocumentKindSetFieldDefs
  do begin

    ChangeDocumentKindTreeListColumnIfNecessary(
      DocumentKindIdColumn, DocumentKindIdFieldName, '', False
    );

    ChangeDocumentKindTreeListColumnIfNecessary(
      TopLevelDocumentKindIdColumn, TopLevelDocumentKindIdFieldName, '', False
    );

    ChangeDocumentKindTreeListColumnIfNecessary(
      DocumentKindNameColumn, DocumentKindNameFieldName, 'Наименование'
    );

    ChangeDocumentKindTreeListColumnIfNecessary(
      DocumentKindOriginalNameColumn, OriginalDocumentKindNameFieldName, 'Наименование', False
    );

    DataController.KeyField := DocumentKindIdFieldName;
    DataController.ParentField := TopLevelDocumentKindIdFieldName;
    
  end;

end;

destructor TDocumentTypesPanelController.Destroy;
begin

  FreeAndNil(FDocumentKindsFormViewModelMapper);
  
  inherited;

end;

procedure TDocumentTypesPanelController.FillDocumentKindsControlFrom(
  DocumentFlowPrimaryScreen: TWinControl;
  GlobalDocumentKindDtos: TGlobalDocumentKindDtos
);

var

    DocumentKindsFormViewModel: TDocumentKindsFormViewModel;
    DocumentKindSetHolder: TDocumentKindSetHolder;
    DocumentKindTreeList: TcxDBTreeList;
    DocumentFlowWorkingForm: TDocumentFlowWorkingForm;
begin

  DocumentFlowWorkingForm := DocumentFlowPrimaryScreen as TDocumentFlowWorkingForm;

  DocumentKindTreeList := DocumentFlowWorkingForm.DocumentKindTreeList;
  
  DocumentKindsFormViewModel :=
    FDocumentKindsFormViewModelMapper.MapDocumentKindsFormViewModelFrom(
      GlobalDocumentKindDtos
    );

  try

    DocumentKindSetHolder := DocumentKindsFormViewModel.DocumentKindSetHolder;

    DocumentKindTreeList.BeginUpdate;

    try

      SetDocumentKindTreeListLayoutIfNecessary(
        DocumentFlowWorkingForm, DocumentKindSetHolder.FieldDefs
      );

      DocumentKindTreeList.DataController.DataSource.DataSet :=
        DocumentKindSetHolder.ExtractDataSet;

    finally

      DocumentKindTreeList.EndUpdate;

    end;

  finally

    FreeAndNil(DocumentKindsFormViewModel);

  end;

end;

procedure TDocumentTypesPanelController.SetEmployeeDocumentWorkStatistics(
  DocumentFlowPrimaryScreen: TWinControl;
  EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList
);
var EmployeeDocumentKindWorkStatistics: TEmployeeDocumentKindWorkStatistics;
    DocumentKindTreeNode: TcxDBTreeListNode;
    DocumentKindNameColumn: TcxDBTreeListColumn;
    DocumentKindOriginalNameColumn: TcxDBTreeListColumn;
    DocumentKindTreeList: TcxDBTreeList;
    DocumentFlowWorkingForm: TDocumentFlowWorkingForm;
begin

  DocumentFlowWorkingForm := DocumentFlowPrimaryScreen as TDocumentFlowWorkingForm;

  DocumentKindTreeList := DocumentFlowWorkingForm.DocumentKindTreeList;

  DocumentKindNameColumn := DocumentFlowWorkingForm.DocumentKindNameColumn;
  DocumentKindOriginalNameColumn := DocumentFlowWorkingForm.DocumentKindOriginalNameColumn;

  for

      EmployeeDocumentKindWorkStatistics in
      EmployeeDocumentWorkStatisticsList

  do begin

    DocumentKindTreeNode :=
      DocumentKindTreeList.FindNodeByKeyValue(
        FUIDocumentKindResolver.ResolveIdForUIDocumentKind(
          FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(
            EmployeeDocumentKindWorkStatistics.DocumentKindId
          )
        )
      );

    if (EmployeeDocumentKindWorkStatistics.OwnActionDocumentCount = 0) and
       (EmployeeDocumentKindWorkStatistics.InWorkingDocumentCount = 0)
    then begin

      DocumentKindTreeNode.Values[
        DocumentKindNameColumn.ItemIndex
      ] := DocumentKindTreeNode.Values[DocumentKindOriginalNameColumn.ItemIndex];

    end

    else begin

      DocumentKindTreeNode.Values[
        DocumentKindNameColumn.ItemIndex
      ] :=
        DocumentKindTreeNode.Values[DocumentKindOriginalNameColumn.ItemIndex] +
        ' (' +
        IntToStr(EmployeeDocumentKindWorkStatistics.OwnActionDocumentCount) +
        '/' +
        IntToStr(EmployeeDocumentKindWorkStatistics.InWorkingDocumentCount) +
        ')';

    end;

  end;
  
end;

procedure TDocumentTypesPanelController.
  ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
    DocumentFlowPrimaryScreen: TWinControl;
    DocumentKind: TUIDocumentKindClass;
    const LoadingStatisticsLabel: String
  );
var DocumentKindTreeNode: TcxDBTreeListNode;
    DocumentKindNameColumn: TcxDBTreeListColumn;
    DocumentKindOriginalNameColumn: TcxDBTreeListColumn;
    DocumentKindId: Variant;
    DocumentKindTreeList: TcxDBTreeList;
    DocumentFlowWorkingForm: TDocumentFlowWorkingForm;
begin

  DocumentFlowWorkingForm := DocumentFlowPrimaryScreen as TDocumentFlowWorkingForm;

  DocumentKindTreeList := DocumentFlowWorkingForm.DocumentKindTreeList;

  DocumentKindId :=
    FUIDocumentKindResolver.ResolveIdForUIDocumentKind(DocumentKind);

  DocumentKindNameColumn := DocumentFlowWorkingForm.DocumentKindNameColumn;
  DocumentKindOriginalNameColumn := DocumentFlowWorkingForm.DocumentKindOriginalNameColumn;

  DocumentKindTreeNode := DocumentKindTreeList.FindNodeByKeyValue(DocumentKindId);

  if not Assigned(DocumentKindTreeNode) then begin

    raise Exception.CreateFmt(
      'Не найден раздел для вида документов ' +
      'с идентификатором %s',
      [VarToStr(DocumentKindId)]
    );

  end;

  DocumentKindTreeNode.Values[
    DocumentKindNameColumn.ItemIndex
  ] :=

  DocumentKindTreeNode.Values[DocumentKindOriginalNameColumn.ItemIndex] +
    ' ' + LoadingStatisticsLabel;

end;

procedure TDocumentTypesPanelController.
  ShowLoadingEmployeeDocumentWorkStatisticsLabel(
    DocumentFlowPrimaryScreen: TWinControl;
    const LoadingStatisticsLabel: String
  );
begin

  ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
    DocumentFlowPrimaryScreen,
    TUIOutcomingServiceNoteKind,
    LoadingStatisticsLabel
  );

  ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
    DocumentFlowPrimaryScreen,
    TUIIncomingServiceNoteKind,
    LoadingStatisticsLabel
  );

  ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
    DocumentFlowPrimaryScreen,
    TUIApproveableServiceNoteKind,
    LoadingStatisticsLabel
  );
  
end;

end.

unit unSelectionDepartmentsReferenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DocumentFlowBaseReferenceFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, cxControls,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxLocalization, ActnList, ImgList, PngImageList,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, ComCtrls, ExtCtrls, StdCtrls,
  cxButtons, ToolWin, SelectionDepartmentsReferenceFormViewModel,
  SelectionDepartmentSetHolder, DepartmentSetHolder,
  SelectionDepartmentsReferenceFormViewModelMapper, DepartmentSetReadService,
  DBDataTableFormUnit, DepartmentRecordViewModel, cxCheckBox;

type

  TOnDepartmentSelectionChangedEventHandler =
    procedure (
      Sender: TObject;
      DepartmentRecordViewModel: TDepartmentRecordViewModel
    ) of object;
    
  TSelectionDepartmentsReferenceForm = class(TDocumentFlowBaseReferenceForm)
    DepartmentShortNameColumn: TcxGridDBColumn;
    DepartmentCodeColumn: TcxGridDBColumn;
    DepartmentFullNameColumn: TcxGridDBColumn;
    IdColumn: TcxGridDBColumn;
    procedure IsSelectedColumnPropertiesEditValueChanged(Sender: TObject);
  private

    FViewModel: TSelectionDepartmentsReferenceFormViewModel;
    FViewModelMapper: TSelectionDepartmentsReferenceFormViewModelMapper;

    procedure SetViewModel(
      const Value: TSelectionDepartmentsReferenceFormViewModel
    );

    procedure UpdateByViewModel(ViewModel: TSelectionDepartmentsReferenceFormViewModel);

    procedure SetColumnLayoutFrom(FieldDefs: TSelectionDepartmentSetFieldDefs);

  private

    FOnDepartmentSelectionChangedEventHandler: TOnDepartmentSelectionChangedEventHandler;

  private

    function CreateCurrentDepartmentRecordViewModel: TDepartmentRecordViewModel;
    function CreateDepartmentRecordViewModelFrom(GridRecord: TcxCustomGridRecord): TDepartmentRecordViewModel;

  protected

    procedure Init(
      const Caption: String = ''; ADataSet:
      TDataSet = nil
    ); override;

    function GetTotalRecordCountPanelLabel: String; override;
    
    procedure OnRefreshRecords; override;

    procedure AdjustSearchByColumnPanel; override;

    procedure OnDataLoadingSuccessHandle(Sender: TObject; DataSet: TDataSet; RelatedState: TObject; const IsDestroyingRequested: Boolean); overload; override;

  public

    destructor Destroy; override;
    
    property ViewModel: TSelectionDepartmentsReferenceFormViewModel
    read FViewModel write SetViewModel;

  public

    property OnDepartmentSelectionChangedEventHandler: TOnDepartmentSelectionChangedEventHandler
    read FOnDepartmentSelectionChangedEventHandler write FOnDepartmentSelectionChangedEventHandler;
    
  end;

var
  SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm;

implementation

uses

  AuxDebugFunctionsUnit,
  ApplicationServiceRegistries,
  PresentationServiceRegistry;

{$R *.dfm}

{ TSelectionDepartmentsReferenceForm }

procedure TSelectionDepartmentsReferenceForm.AdjustSearchByColumnPanel;
begin

end;

function TSelectionDepartmentsReferenceForm.
  CreateCurrentDepartmentRecordViewModel: TDepartmentRecordViewModel;
begin

  Result := CreateDepartmentRecordViewModelFrom(DataRecordGridTableView.Controller.FocusedRecord);

end;

function TSelectionDepartmentsReferenceForm.CreateDepartmentRecordViewModelFrom(
  GridRecord: TcxCustomGridRecord): TDepartmentRecordViewModel;
begin

  Result := TDepartmentRecordViewModel.Create;

  try

    Result.Id := GetRecordCellValue(GridRecord, IdColumn.Index);
    Result.IsSelected := GetRecordCellValue(GridRecord, IsSelectedColumn.Index);
    Result.Code := GetRecordCellValue(GridRecord, DepartmentCodeColumn.Index);
    Result.ShortName := GetRecordCellValue(GridRecord, DepartmentShortNameColumn.Index);
    Result.FullName := GetRecordCellValue(GridRecord, DepartmentFullNameColumn.Index);
    
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

destructor TSelectionDepartmentsReferenceForm.Destroy;
begin

  FreeAndNil(FViewModel);
  FreeAndNil(FViewModelMapper);
  
  inherited;

end;

function TSelectionDepartmentsReferenceForm.GetTotalRecordCountPanelLabel: String;
begin

  Result := 'Количество подразделений: ';
  
end;

procedure TSelectionDepartmentsReferenceForm.Init(
  const Caption: String;
  ADataSet: TDataSet
);
begin

  inherited;

  FViewModelMapper := TSelectionDepartmentsReferenceFormViewModelMapper.Create;
  
end;

procedure TSelectionDepartmentsReferenceForm.IsSelectedColumnPropertiesEditValueChanged(
  Sender: TObject
);
var
    DepartmentRecordViewModel: TDepartmentRecordViewModel;
begin

  inherited;

  TcxCheckBox(Sender).PostEditValue;

  if not Assigned(FOnDepartmentSelectionChangedEventHandler) then Exit;
  
  DepartmentRecordViewModel := CreateCurrentDepartmentRecordViewModel;

  try

    FOnDepartmentSelectionChangedEventHandler(Self, DepartmentRecordViewModel);

  finally

    FreeAndNil(DepartmentRecordViewModel);

  end;

end;

procedure TSelectionDepartmentsReferenceForm.OnDataLoadingSuccessHandle(
  Sender: TObject;
  DataSet: TDataSet;
  RelatedState: TObject;
  const IsDestroyingRequested: Boolean
);
begin

  inherited;

  if IsDestroyingRequested then Exit;

  DataSet.FindField(
    ViewModel.SelectionDepartmentSetHolder.IsSelectedFieldName
  ).ReadOnly := False;
  
end;

procedure TSelectionDepartmentsReferenceForm.OnRefreshRecords;
var
    DepartmentSetReadService: IDepartmentSetReadService;
    DepartmentSetHolder: TDepartmentSetHolder;
begin

  DepartmentSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetDepartmentSetReadService;

  DepartmentSetHolder := DepartmentSetReadService.GetPreparedDepartmentSet;

  try

    ViewModel :=
      FViewModelMapper.MapSelectionDepartmentsReferenceFormViewModelFrom(
        DepartmentSetHolder
      );
      
  finally

    FreeAndNil(DepartmentSetHolder);

  end;

  inherited;

end;

procedure TSelectionDepartmentsReferenceForm.SetColumnLayoutFrom(
  FieldDefs: TSelectionDepartmentSetFieldDefs);
begin

  with FieldDefs do begin

    IsSelectedColumn.DataBinding.FieldName := IsSelectedFieldName;
    IsSelectedColumn.Caption := '';
    
    DepartmentCodeColumn.DataBinding.FieldName := CodeFieldName;
    DepartmentShortNameColumn.DataBinding.FieldName := ShortNameFieldName;
    DepartmentFullNameColumn.DataBinding.FieldName := FullNameFieldName;
    IdColumn.DataBinding.FieldName := DepartmentIdFieldName;

    DataRecordGridTableView.DataController.KeyFieldNames := DepartmentIdFieldName;
    
  end;
  
end;

procedure TSelectionDepartmentsReferenceForm.SetViewModel(
  const Value: TSelectionDepartmentsReferenceFormViewModel
);
var
    PrevViewModel: TSelectionDepartmentsReferenceFormViewModel;
begin

  if FViewModel = Value then Exit;

  PrevViewModel := FViewModel;
  
  FViewModel := Value;

  UpdateByViewModel(FViewModel);

  FreeAndNil(PrevViewModel);
  
end;

procedure TSelectionDepartmentsReferenceForm.UpdateByViewModel(
  ViewModel: TSelectionDepartmentsReferenceFormViewModel
);
begin

  SetColumnLayoutFrom(ViewModel.SelectionDepartmentSetHolder.FieldDefs);

  DataSet := ViewModel.SelectionDepartmentSetHolder.DataSet;

end;

end.

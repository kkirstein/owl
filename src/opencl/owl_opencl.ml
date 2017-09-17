(*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2017 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)

open Ctypes

open Owl_opencl_generated


module Platform = struct

  let uint32_0 = Unsigned.UInt32.of_int 0


  let get_platform_ids () =
    let _n = allocate uint32_t uint32_0 in
    clGetPlatformIDs uint32_0 cl_platform_id_ptr_null _n |> cl_check_err;
    let n = Unsigned.UInt32.to_int !@_n in
    let _platforms = allocate_n cl_platform_id n in
    clGetPlatformIDs !@_n _platforms (Obj.magic null) |> cl_check_err;
    Array.init n (fun i -> !@(_platforms +@ i))


  let get_platform_info plf_id typ =
    let n = 1024 in
    let _n = Unsigned.Size_t.of_int n in
    let typ = Unsigned.UInt32.of_int typ in
    let _buf = allocate_n char ~count:n in
    let _ptr = coerce (ptr char) (ptr void) _buf in
    clGetPlatformInfo plf_id typ _n _ptr (Obj.magic null) |> cl_check_err;
    let s = Ctypes.string_from_ptr _buf n in
    String.(sub s 0 (index s '\000'))


  let get_device_ids plf_id =
    let dev_typ = Unsigned.UInt64.of_int cl_DEVICE_TYPE_ALL in
    let num_entries = Unsigned.UInt32.of_int 0 in
    let _num_devices = allocate uint32_t uint32_0 in
    clGetDeviceIDs plf_id dev_typ num_entries cl_device_id_ptr_null _num_devices |> cl_check_err;

    let num_entries = Unsigned.UInt32.to_int !@_num_devices in
    let _devices = allocate_n cl_device_id num_entries in
    clGetDeviceIDs plf_id dev_typ !@_num_devices _devices (Obj.magic null) |> cl_check_err;
    Array.init num_entries (fun i -> !@(_devices +@ i))


  let get_device_info dev_id = ()

end
